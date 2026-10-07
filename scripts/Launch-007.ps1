[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('quantumofsolace', 'bloodstone', 'legends')]
    [string] $Game,
    [Parameter(Mandatory = $true)]
    [string] $GameRoot,
    [string] $Executable,
    [switch] $PrintCommand
)

$ErrorActionPreference = 'Stop'
$titleFolders = @{
    quantumofsolace = 'Quantum of Solace'
    bloodstone = 'Blood Stone'
    legends = 'Legends'
}
$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $Executable) {
    $projectRoot = Join-Path $repoRoot ($titleFolders[$Game] + '/recompiled')
    $candidates = @(
        (Join-Path $projectRoot "out/build/win-amd64-gdk-release/$Game.exe"),
        (Join-Path $projectRoot "out/build/release/$Game.exe"),
        (Join-Path $projectRoot "out/build/win-amd64-release/$Game.exe")
    )
    $Executable = $candidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } |
        Select-Object -First 1
    if (-not $Executable) {
        throw "Build $Game first, or supply -Executable with the path to your build."
    }
}
$exePath = (Resolve-Path -LiteralPath $Executable).Path
$sourcePath = (Resolve-Path -LiteralPath $GameRoot).Path
if (-not (Test-Path -LiteralPath $exePath -PathType Leaf) -or
    -not (Test-Path -LiteralPath $sourcePath -PathType Container)) {
    throw 'Executable must be a file and GameRoot must be a folder.'
}
$launchArguments = @(
    "--game_data_root=$sourcePath",
    '--gpu_plugin=xenos',
    '--fullscreen=true',
    '--fullscreen_exclusive=false',
    '--launch_menu=false',
    '--log_level=warn',
    '--log_verbose=false',
    '--log_noisy=false',
    '--frame_stats_interval=0'
)
if ($PrintCommand) {
    [pscustomobject]@{ Executable = $exePath; Arguments = $launchArguments }
    return
}
Push-Location -LiteralPath (Split-Path -Parent $exePath)
try {
    & $exePath @launchArguments
} finally {
    Pop-Location
}
