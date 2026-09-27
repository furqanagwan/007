<p align="center"><img src="assets/logo.svg" width="128" alt="007 recompilation logo"></p>

# 007 — Xbox 360 recompilation

The Xbox 360 James Bond games, statically recompiled to native Windows PC
executables with [ReXGlue](https://github.com/furqanagwan/rexglue-sdk):
Direct3D 12 rendering, native input and audio, and an optional Microsoft GDK
build.

> [!IMPORTANT]
> This repository contains no game files. You need your own legally obtained
> copy of each game. Disc images, extracted files, generated code, builds,
> saves and logs stay on your machine.

## Games

| Game | Released | Disc (Redump name) | Region | Languages | Title ID | Media ID | Executable | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Quantum of Solace | 2008 · Treyarch | `007 - Quantum of Solace (USA, Europe) (En,Fr)` | USA and Europe, one disc; the XEX is region-free | English, French | `415607FF` | `06DD88A0` | `default.xex` v7, disc 1/1, no title update | **In-game** |
| Blood Stone | 2010 · Bizarre Creations | Not yet identified | — | — | — | — | — | **Planned** |
| 007 Legends | 2012 · Eurocom | Not yet identified | — | — | — | — | — | **Planned** |

**Status levels:**

- **Planned:** not started.
- **Investigating:** recompiles, but doesn't reach gameplay yet.
- **In-game:** reaches gameplay, but not validated end to end.
- **Playable:** validated through the game, within the limits listed.

## Quantum of Solace status

**What works** on an NVIDIA RTX 5080 Laptop GPU, with ReXGlue `main` `0d7568a`:

- **Boot to the first level:** it boots from the publisher logos to the first
  level, with textured 3D, the HUD and mission objectives.
- **Achievements:** the first achievement unlocks.
- **Input:** a controller works through SDL or, in GDK builds, GameInput.
  Keyboard input hasn't been confirmed.
- **Audio:** plays through SDL or XAudio2.
- **Soak test:** 90-second runs have zero error lines in both the standard and
  the GDK build ([SDK baseline record](https://github.com/furqanagwan/rexglue-sdk/blob/main/docs/baseline-capture.md)).

**Not validated yet** ([#16](https://github.com/furqanagwan/007/issues/16)):

- a full playthrough;
- saving and loading;
- visual accuracy against a real console;
- AMD and Intel GPUs.

**Multiplayer:** not recompiled (`default_mp.xex`).

**How it got here:** the boot needed guest function entries the recompiler
couldn't find on its own. [`configs/quantumofsolace.toml`](configs/quantumofsolace.toml)
adds them, and the records for [RG-007-001](docs/RG-007-001.md) to
[RG-007-004](docs/RG-007-004.md) trace each one.

## Requirements

- **Your own copy of the game.** For Quantum of Solace, the disc above; check
  the title and media IDs match.
- **Windows 11 x64 and a Direct3D 12 GPU.** Only NVIDIA has been tested.
- **The build tools:** Visual Studio 2026 with LLVM Clang, CMake and Ninja, as
  listed in the [SDK README](https://github.com/furqanagwan/rexglue-sdk#requirements).
- **The ReXGlue SDK** from [furqanagwan/rexglue-sdk](https://github.com/furqanagwan/rexglue-sdk),
  built and installed from `main` `0d7568a` or later.
- **Optional:** Microsoft GDK 260404, for the GDK build (GameInput, XAudio2,
  the Gaming Runtime and MSIXVC packaging).

## Build Quantum of Solace

Keep everything in a private folder next to this repository, such as
`Quantum of Solace/`, which is ignored.

1. **Extract the files** from your disc image, for example with
   [extract-xiso](https://github.com/XboxDev/extract-xiso), into
   `Quantum of Solace/game/`.
2. **Create the project:**

   ```powershell
   rexglue init --project-name quantumofsolace --xex-path "Quantum of Solace/game/default.xex" --game-root "Quantum of Solace/game" --project-root "Quantum of Solace/recompiled"
   ```

3. **Add the title configuration** to the entry point's `includes` in
   `Quantum of Solace/recompiled/quantumofsolace_manifest.toml`. The path is
   relative to that file:

   ```toml
   includes = ["../../configs/quantumofsolace.toml"]
   ```

4. **Generate and build** against the installed SDK:

   ```powershell
   cd "Quantum of Solace/recompiled"
   rexglue codegen
   cmake -S . -B out/build/release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_PREFIX_PATH=<ReXGlue install prefix>
   cmake --build out/build/release
   ```

   For the GDK build, use the SDK's GDK install prefix (`out/install/win-amd64-gdk`).

5. **Run it:**

   ```powershell
   .\out\build\release\quantumofsolace.exe --game_data_root="<...>/Quantum of Solace/game" --user_data_root="<...>/Quantum of Solace/saves" --gpu_plugin=xenos
   ```

   GDK builds can add `--input_backend=gameinput --ui_backend=win32 --audio_backend=xaudio2`.

## Repository layout

```text
assets/                      Original artwork (logo, social preview)
configs/quantumofsolace.toml Guest function entries for Quantum of Solace codegen
docs/RG-007-NNN.md           One record per issue: goal, evidence, result
```

Everything else in the folder is ignored (`.gitignore` is an allowlist).

## Issues and records

- **Tracking:** work is tracked as [issues](https://github.com/furqanagwan/007/issues)
  with IDs `RG-007-NNN`. Each has a record in `docs/`, with the tested
  executable's hashes, the SDK commit, the hardware and what was and wasn't
  checked.
- **Where fixes go:** fixes that help every title go to
  [rexglue-sdk](https://github.com/furqanagwan/rexglue-sdk). Only what's
  specific to one of these games belongs here.
- **Standard:** this repository follows the
  [title repository standard](https://github.com/furqanagwan/rexglue-sdk/blob/main/docs/title-repo-standard.md).

## Legal

007, James Bond and the game titles are trademarks of their respective owners.
This is an independent preservation and research project, not affiliated with
or endorsed by them. It contains no game code or assets, and the artwork in
`assets/` is original.

## Credits

- [ReXGlue](https://github.com/rexglue/rexglue-sdk), the static recompilation
  SDK this builds on, and its authors.
- [Xenia](https://github.com/xenia-project/xenia),
  [Xenia Canary](https://github.com/xenia-canary/xenia-canary) and
  [Xenia Edge](https://github.com/has207/xenia-edge), whose Xbox 360 research
  the runtime draws on.
