[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\d+\.\d+\.\d+(-(alpha|beta|rc)\.\d+)?$')]
    [string] $Version,
    [Parameter(Mandatory = $true)]
    [string] $SystemUpdate,
    [hashtable] $GameSources = @{},
    [string] $SdkRoot,
    [string] $ShaderCacheRoot,
    [string] $SmokeProfileRoot,
    [int] $SmokeSeconds = 180,
    [switch] $SkipSmoke,
    [switch] $AllowDirty,
    [switch] $Publish
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $SdkRoot) { $SdkRoot = Join-Path (Split-Path -Parent $repoRoot) 'rexglue-sdk' }
if (-not $SmokeProfileRoot) { $SmokeProfileRoot = Join-Path $repoRoot 'out/test-profiles' }
$workRoot = Join-Path $repoRoot "out/release/$Version"
$tag = "v$Version"

$games = @(
    @{ Name = 'quantumofsolace'; Folder = 'Quantum of Solace'; Asset = 'QuantumOfSolace'; Title = 'Quantum of Solace' },
    @{ Name = 'bloodstone'; Folder = 'Blood Stone'; Asset = 'BloodStone'; Title = 'James Bond 007: Blood Stone' },
    @{ Name = 'legends'; Folder = 'Legends'; Asset = 'Legends'; Title = '007 Legends' }
)
$runtimeLibraries = @('msvcp140.dll', 'msvcp140_atomic_wait.dll', 'vcruntime140.dll', 'vcruntime140_1.dll')
$allowedExtensions = @('.exe', '.dll', '.txt', '.xsh', '.xpso')

function Write-Step([string] $Message) { Write-Host "== $Message" }

function Invoke-Checked([string] $FilePath, [string[]] $Arguments, [string] $WorkingDirectory) {
    Push-Location $WorkingDirectory
    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & $FilePath @Arguments 2>&1 | ForEach-Object { "$_" }
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previousPreference
        Pop-Location
    }
    if ($exitCode -ne 0) { throw "$FilePath $($Arguments -join ' ') failed with exit code $exitCode" }
}

function Assert-ReleaseCheckout([string] $Path, [string] $Name) {
    if ($AllowDirty) { return }
    if (git -C $Path status --porcelain) { throw "$Name has uncommitted changes" }
    $branch = git -C $Path rev-parse --abbrev-ref HEAD
    if ($branch -ne 'main') { throw "$Name is on '$branch', not main" }
    git -C $Path fetch --quiet origin main
    if ((git -C $Path rev-parse HEAD) -ne (git -C $Path rev-parse origin/main)) {
        throw "$Name main is not the same commit as origin/main"
    }
}

function Import-VisualStudioEnvironment {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    $vsPath = & $vswhere -latest -prerelease -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if (-not $vsPath) { throw 'Visual Studio with the C++ tools was not found' }
    $vcvars = Join-Path $vsPath 'VC\Auxiliary\Build\vcvars64.bat'
    $env:PATH = "$(Split-Path $vswhere);$env:PATH"
    foreach ($line in (cmd /c "`"$vcvars`" >nul 2>nul && set")) {
        if ($line -match '^([^=]+)=(.*)$') { Set-Item -Path "env:$($Matches[1])" -Value $Matches[2] }
    }
    return $vsPath
}

function Find-RuntimeLibraryFolder([string] $VsPath) {
    $folder = Get-ChildItem (Join-Path $VsPath 'VC\Redist\MSVC') -Directory |
        Where-Object { $_.Name -match '^\d+\.\d+\.\d+$' } |
        Sort-Object { [version]$_.Name } -Descending |
        ForEach-Object { Get-ChildItem (Join-Path $_.FullName 'x64') -Directory -Filter 'Microsoft.VC*.CRT' -ErrorAction SilentlyContinue } |
        Select-Object -First 1
    if (-not $folder) { throw 'The Visual C++ redistributable files were not found' }
    return $folder.FullName
}

Add-Type -TypeDefinition @'
public static class ByteSearch {
    public static bool Contains(byte[] haystack, byte[] needle) {
        if (needle.Length == 0 || needle.Length > haystack.Length) return false;
        int last = haystack.Length - needle.Length;
        for (int i = System.Array.IndexOf(haystack, needle[0]); i >= 0 && i <= last;
             i = System.Array.IndexOf(haystack, needle[0], i + 1)) {
            int j = 1;
            while (j < needle.Length && haystack[i + j] == needle[j]) j++;
            if (j == needle.Length) return true;
        }
        return false;
    }
}
'@

function Assert-GuideBuiltIn([string] $Executable, [string] $Bundle) {
    if (-not (Test-Path -LiteralPath $Bundle)) { throw "No Guide bundle at $Bundle; was REXGLUE_SYSTEM_UPDATE set?" }
    $bundleBytes = [System.IO.File]::ReadAllBytes($Bundle)
    $sample = New-Object byte[] ([Math]::Min(4096, $bundleBytes.Length))
    [Array]::Copy($bundleBytes, $sample, $sample.Length)
    if (-not [ByteSearch]::Contains([System.IO.File]::ReadAllBytes($Executable), $sample)) {
        throw "$Executable does not contain the Xbox 360 Guide bundle"
    }
}

function Assert-ReleaseContents([string] $Folder) {
    foreach ($file in Get-ChildItem -LiteralPath $Folder -Recurse -File) {
        if ($allowedExtensions -notcontains $file.Extension.ToLowerInvariant()) {
            throw "Unexpected file in the release: $($file.FullName)"
        }
    }
}

function Invoke-SmokeRun([hashtable] $Game, [string] $Executable, [string] $Source, [string] $LogFile) {
    $profileFolder = Join-Path $SmokeProfileRoot $Game.Name
    New-Item -ItemType Directory -Force $profileFolder | Out-Null
    $arguments = @("--game_data_root=`"$Source`"", "--user_data_root=`"$profileFolder`"",
        "--log_file=`"$LogFile`"", '--fullscreen=true', '--fullscreen_exclusive=false',
        '--launch_menu=false', '--log_level=info', '--frame_stats_interval=5')
    $process = Start-Process -FilePath $Executable -ArgumentList $arguments `
        -WorkingDirectory (Split-Path $Executable) -PassThru
    $started = Get-Date
    while (((Get-Date) - $started).TotalSeconds -lt $SmokeSeconds -and -not $process.HasExited) {
        Start-Sleep -Seconds 2
    }
    $alive = -not $process.HasExited
    if ($alive) {
        $process.CloseMainWindow() | Out-Null
        if (-not $process.WaitForExit(20000)) { Stop-Process -Id $process.Id -Force }
    }
    $log = if (Test-Path -LiteralPath $LogFile) { Get-Content -LiteralPath $LogFile } else { @() }
    $critical = @($log | Where-Object { $_ -match '\[critical\]' }).Count
    $errors = @($log | Where-Object { $_ -match '\[error\]' }).Count
    "{0}: ran {1} s, alive at the end: {2}, errors {3}, critical {4}" -f $Game.Title, $SmokeSeconds, $alive, $errors, $critical
    if (-not $alive -or $critical -gt 0) { throw "$($Game.Title) failed its smoke run; see $LogFile" }
}

function Get-ChangelogSection([string] $Path, [string] $SectionVersion) {
    $lines = Get-Content -LiteralPath $Path
    $start = [Array]::FindIndex($lines, [Predicate[string]] { param($l) $l -match "^## \[$([regex]::Escape($SectionVersion))\]" })
    if ($start -lt 0) { throw "CHANGELOG.md has no section for $SectionVersion" }
    $end = [Array]::FindIndex($lines, $start + 1, [Predicate[string]] { param($l) $l -match '^## \[' })
    if ($end -lt 0) { $end = $lines.Length }
    return ($lines[($start + 1)..($end - 1)] -join "`n").Trim()
}

Write-Step "Checking the repositories"
Assert-ReleaseCheckout $repoRoot '007'
Assert-ReleaseCheckout $SdkRoot 'rexglue-sdk'
if (-not (Test-Path -LiteralPath $SystemUpdate -PathType Container)) { throw "SystemUpdate folder not found: $SystemUpdate" }
$notes = Get-ChangelogSection (Join-Path $repoRoot 'CHANGELOG.md') $Version
$sdkCommit = git -C $SdkRoot rev-parse --short HEAD
$gamesCommit = git -C $repoRoot rev-parse --short HEAD
if (Test-Path -LiteralPath $workRoot) { Remove-Item -Recurse -Force -LiteralPath $workRoot }
New-Item -ItemType Directory -Force $workRoot | Out-Null

$vsPath = Import-VisualStudioEnvironment
$runtimeLibraryFolder = Find-RuntimeLibraryFolder $vsPath
$systemUpdatePath = (Resolve-Path -LiteralPath $SystemUpdate).Path -replace '\\', '/'

Write-Step "Building and installing the SDK ($sdkCommit)"
$sdkPrefix = Join-Path $workRoot 'sdk'
Invoke-Checked 'cmake' @('--preset', 'win-amd64-gdk') $SdkRoot
Invoke-Checked 'cmake' @('--build', 'out/build/win-amd64-gdk', '--config', 'Release', '--parallel') $SdkRoot
Invoke-Checked 'cmake' @('--install', 'out/build/win-amd64-gdk', '--config', 'Release', '--prefix', $sdkPrefix) $SdkRoot
$rexglue = Join-Path $sdkPrefix 'bin/rexglue.exe'

$assets = @()
$smokeResults = @()
foreach ($game in $games) {
    $name = $game.Name
    Write-Step "Building $($game.Title)"
    $project = Join-Path $workRoot "build/$name"
    & robocopy (Join-Path $repoRoot "$($game.Folder)/recompiled") $project /E /XD generated out shader_cache /NFL /NDL /NJH /NJS /NP | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "Copying the $name project failed" }
    if ($ShaderCacheRoot -and (Test-Path -LiteralPath (Join-Path $ShaderCacheRoot $name))) {
        Copy-Item -Recurse -LiteralPath (Join-Path $ShaderCacheRoot $name) (Join-Path $project 'shader_cache')
    }
    Invoke-Checked $rexglue @('codegen', "${name}_manifest.toml") $project
    $buildDir = Join-Path $project 'out/build/release'
    Invoke-Checked 'cmake' @('-S', '.', '-B', $buildDir, '-G', 'Ninja', '-DCMAKE_BUILD_TYPE=Release',
        '-DCMAKE_C_COMPILER=clang', '-DCMAKE_CXX_COMPILER=clang++', "-DCMAKE_PREFIX_PATH=$sdkPrefix",
        "-DREXGLUE_SYSTEM_UPDATE=$systemUpdatePath") $project
    Invoke-Checked 'cmake' @('--build', $buildDir, '--target', $name, '--parallel') $project

    $assetBase = "007-$($game.Asset)-$Version-win-x64"
    $stage = Join-Path $workRoot "stage/$assetBase"
    New-Item -ItemType Directory -Force $stage | Out-Null
    Copy-Item (Join-Path $buildDir "$name.exe"), (Join-Path $buildDir 'rexruntime.dll'), (Join-Path $buildDir 'rexgpu-xenos.dll') $stage
    foreach ($library in $runtimeLibraries) { Copy-Item (Join-Path $runtimeLibraryFolder $library) $stage }
    if (Test-Path -LiteralPath (Join-Path $buildDir 'shader_cache')) {
        Copy-Item -Recurse (Join-Path $buildDir 'shader_cache') (Join-Path $stage 'shader_cache')
    }
    @(
        "$($game.Title)", "Version $Version", "",
        "Built from furqanagwan/007 $gamesCommit and furqanagwan/rexglue-sdk $sdkCommit",
        "on $(Get-Date -Format 'yyyy-MM-dd')."
    ) | Set-Content -Encoding utf8 (Join-Path $stage 'version.txt')
    @(
        "$($game.Title) - 007 Recompiled $Version (alpha)",
        "",
        "No game files are included. You need your own copy of the game.",
        "",
        "1. Unzip this folder anywhere.",
        "2. Run $name.exe.",
        "3. The first time, choose your disc image (.iso) or game folder in the picker.",
        "4. Press View and Menu together (or the Xbox button) for the Xbox 360 Guide.",
        "",
        "Needs Windows 11 x64, a Direct3D 12 GPU and an Xbox controller.",
        "",
        "Saves:    %USERPROFILE%\Saved Games\$name",
        "Settings, logs and caches: %LOCALAPPDATA%\$name",
        "Updating: replace these files with the new release's; saves and settings stay.",
        "",
        "This is an alpha. Known issues and changes: https://github.com/furqanagwan/007/releases",
        "Report problems: https://github.com/furqanagwan/007/issues"
    ) | Set-Content -Encoding utf8 (Join-Path $stage 'README.txt')

    Assert-GuideBuiltIn (Join-Path $stage "$name.exe") (Join-Path $buildDir "rexglue_guide/${name}_xbox_guide.bin")
    Assert-ReleaseContents $stage

    if (-not $SkipSmoke) {
        if (-not $GameSources.ContainsKey($name)) { throw "No -GameSources entry for $name; pass one or use -SkipSmoke" }
        Write-Step "Smoke run: $($game.Title)"
        $smokeResults += Invoke-SmokeRun $game (Join-Path $stage "$name.exe") $GameSources[$name] (Join-Path $workRoot "smoke-$name.log")
    }

    $zip = Join-Path $workRoot "$assetBase.zip"
    Compress-Archive -Path $stage -DestinationPath $zip -CompressionLevel Optimal
    $assets += $zip
}

Write-Step "Writing SHA256SUMS.txt"
$sums = Join-Path $workRoot 'SHA256SUMS.txt'
$assets | ForEach-Object { '{0}  {1}' -f (Get-FileHash -Algorithm SHA256 $_).Hash.ToLowerInvariant(), (Split-Path $_ -Leaf) } |
    Set-Content -Encoding ascii $sums
$notesFile = Join-Path $workRoot 'release-notes.md'
Set-Content -Encoding utf8 $notesFile $notes

$smokeResults
Get-Content $sums
if ($Publish) {
    Write-Step "Publishing $tag"
    $prerelease = if ($Version -match '-' -or $Version.StartsWith('0.')) { @('--prerelease') } else { @() }
    Invoke-Checked 'gh' (@('release', 'create', $tag, '--repo', 'furqanagwan/007', '--target', 'main',
        '--title', "007 Recompiled $Version", '--notes-file', $notesFile) + $prerelease + $assets + @($sums)) $repoRoot
} else {
    Write-Step "Built $tag in $workRoot (not published; pass -Publish to create the GitHub release)"
}
