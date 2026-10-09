# Releasing

Releases are GitHub releases of this repository, built on the owner's PC
(building needs each game's own executable, so CI can't). Never the
Microsoft Store. Plan and updater design:
[releases and the updater](https://github.com/furqanagwan/rexglue-sdk/blob/main/research/releases/releases-and-updater.md).

## Versions

`0.1.0-alpha.1`, `0.1.0-alpha.2`, ... while in alpha (Semantic Versioning).
The tag is `v<version>`; everything before `1.0.0` is a pre-release.

## Steps

1. Add a `## [<version>] - <date>` section to [CHANGELOG.md](../CHANGELOG.md)
   and merge it to `main`.
2. Make sure both this repository and `rexglue-sdk` are clean and on the
   same commit as `origin/main`.
3. Build, test and package (nothing is published yet):

   ```powershell
   scripts/Publish-Release.ps1 -Version 0.1.0-alpha.1 `
     -SystemUpdate 'C:\path\to\SystemUpdate_17559_USB\$SystemUpdate' `
     -GameSources @{
       quantumofsolace = 'C:\path\to\Quantum of Solace\game'
       bloodstone      = 'C:\path\to\Blood Stone\game'
       legends         = 'C:\path\to\Legends\game'
     }
   ```

   For each game it installs the SDK to a fresh prefix, regenerates and
   builds the game in `<Game>/recompiled-release-<version>` (beside
   `recompiled`, whose manifest refers to `../`) with the Xbox 360 Guide built in, and stages the
   executable, its two DLLs, the Visual C++ runtime DLLs, `README.txt` and
   `version.txt`. Then it:

   - checks the executable contains the Guide bundle;
   - rejects anything but `.exe`, `.dll`, `.txt` and shader cache files (so
     no `.pdb`, `.iso`, `.xex`, saves or logs);
   - runs the staged game fullscreen for 3 minutes from a persistent test
     profile under `out/test-profiles/<name>` (never reset, so runs continue
     from the last save), failing on a crash or a critical log line;
   - zips it and writes `SHA256SUMS.txt` and `release-notes.md` (the
     changelog section) under `out/release/<version>`.

4. Check the zips, then run the same command with `-Publish`. It creates the
   tag and the pre-release with the zips, checksums and notes.

Options: `-ShaderCacheRoot <dir>` ships recorded shader caches
(`<dir>/<name>/`, see
[shipped shader cache](https://github.com/furqanagwan/rexglue-sdk/blob/main/docs/shader-cache.md));
`-SkipSmoke` skips the runs; `-AllowDirty` skips the clean-checkout check
(for trying the script, never for a real release).

## What players get

One zip per game, `007-<Game>-<version>-win-x64.zip`. They unzip it, run the
executable and pick their own disc image once. Saves and settings live
outside the folder, so a new release just replaces the files.
