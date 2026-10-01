# Building the games

Until releases are published, each game is built from source against the
ReXGlue SDK. Everything you create here stays in the game's folder, which git
ignores apart from its `README.md` and `.toml`.

## Requirements

- **Your own copy of the game:** the disc listed on its page. Check that its
  title and media IDs match.
- **Windows 11 x64 and a Direct3D 12 GPU.** Only NVIDIA has been tested.
- **The build tools:** Visual Studio 2026 with LLVM Clang, CMake and Ninja, as
  listed in the [SDK README](https://github.com/furqanagwan/rexglue-sdk#requirements).
- **The ReXGlue SDK** from [furqanagwan/rexglue-sdk](https://github.com/furqanagwan/rexglue-sdk),
  built and installed from `main`.
- **Optional:** Microsoft GDK 260404, for the GDK build (GameInput, XAudio2,
  the Gaming Runtime and MSIXVC packaging).
- **Optional:** your console's dashboard system update (`$SystemUpdate`), so
  the Xbox guide is built in; see the SDK's
  [Xbox guide](https://github.com/furqanagwan/rexglue-sdk/blob/main/docs/xbox-guide.md#using-it).

| Game | Folder | Project name | Executable | Configuration |
| --- | --- | --- | --- | --- |
| Quantum of Solace | `Quantum of Solace/` | `quantumofsolace` | `default.xex` | `quantumofsolace.toml` |
| Blood Stone | `Blood Stone/` | `bloodstone` | `default.xex` | `bloodstone.toml` |
| 007 Legends | `Legends/` | `legends` | `Default.xex` | `legends.toml` |

The steps use Blood Stone; substitute the row for another game.

## 1. Extract the files

Extract your disc image into `Blood Stone/game/`, for example with
[extract-xiso](https://github.com/XboxDev/extract-xiso).

## 2. Create the project

```powershell
rexglue init --project-name bloodstone --xex-path "Blood Stone/game/default.xex" --game-root "Blood Stone/game" --project-root "Blood Stone/recompiled"
```

## 3. Add the game's configuration

Add the game's `.toml` to the entry point's `includes` in the manifest
(`Blood Stone/recompiled/bloodstone_manifest.toml`). The path is relative to
the manifest:

```toml
[entrypoint]
includes = ["../bloodstone.toml"]
```

The configuration carries the game's codegen settings and its mods, patches,
cheat codes and add-on list, which the Xbox guide shows.

## 4. Generate and build

```powershell
cd "Blood Stone/recompiled"
rexglue codegen
cmake -S . -B out/build/release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_PREFIX_PATH=<ReXGlue install prefix>
cmake --build out/build/release
```

For the GDK build, use the SDK's GDK install prefix (`out/install/win-amd64-gdk`).

## Run it

```powershell
.\out\build\release\bloodstone.exe --game_data_root="<...>/Blood Stone/game" --gpu_plugin=xenos
```

Input, audio and the window use the native backends by default. Saves go to
the per-user location the SDK documents
([data locations](https://github.com/furqanagwan/rexglue-sdk/blob/main/docs/data-locations.md));
`--user_data_root` puts them somewhere else.
