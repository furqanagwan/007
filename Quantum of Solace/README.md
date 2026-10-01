<p align="center"><img src="https://raw.githubusercontent.com/xenia-manager/x360db/main/titles/415607FF/artwork/banner.png" alt="Quantum of Solace marketplace banner"></p>

# Quantum of Solace

The 2008 James Bond shooter, statically recompiled from its Xbox 360
executable into a native Windows PC game with
[ReXGlue](https://github.com/furqanagwan/rexglue-sdk).

It blends the stories of the *Casino Royale* and *Quantum of Solace* films,
with Daniel Craig as Bond. Missions mix first-person shooting with a
third-person cover system, stealth and hand-to-hand takedowns, in locations
such as Montenegro, Venice, Bolivia and Austria.

**Status: In-game.** It reaches gameplay; a full playthrough hasn't been
validated yet.

## The game

| | |
| --- | --- |
| Released | 4 November 2008 (North America) |
| Developer | Treyarch (LaunchBox also credits Nerve Software) |
| Publisher | Activision |
| Genre | Shooter, action-adventure |
| Players | Single-player campaign. Online multiplayer is a separate executable (`default_mp.xex`) and isn't recompiled. |
| Rating | ESRB T (Teen) |

## The release this is built from

| | |
| --- | --- |
| Disc (Redump) | `007 - Quantum of Solace (USA, Europe) (En,Fr)`, one disc |
| Region | USA and Europe; the executable is region-free |
| Languages | English, French |
| Title ID | `415607FF` |
| Media ID | `06DD88A0` |
| Executable | `default.xex` v7 |
| XEX SHA-256 | `a96f4f651cc0937e51aa2f81245b48ba08d71de1b8bef0e33bc2b2bca29caa42` |
| Title update | None applied. Title update 2 exists for this disc (Xbox Unity) and is listed in the guide's Games & Apps > Title Updates, where it's optional ([title updates](https://github.com/furqanagwan/rexglue-sdk/blob/main/docs/title-updates.md)). It can be downloaded there, but the update's own executable isn't built yet: it needs its own function entries, so the guide shows it as Not in Build. |

Check that your disc's title and media IDs match: the recompiled code is only
valid for this executable.

## What works

Tested on an NVIDIA RTX 5080 Laptop GPU.

- **Boot to the first level:** from the publisher logos to the first level,
  with textured 3D, the HUD and mission objectives.
- **Achievements:** unlock with the console's popup; the Xbox guide lists them.
- **Input:** a controller through GameInput (GDK build) or XInput.
- **Audio:** through XAudio2.
- **Frame rate:** 59-60 fps with the Unlock FPS patch on, after the SDK's
  vblank and timer fixes.
- **Soak test:** 90-second runs with no error lines, in the standard and GDK
  builds.

**Not validated yet** ([#16](https://github.com/furqanagwan/007/issues/16)):
a full playthrough, saving and loading through the game, visual accuracy
against a console, and AMD and Intel GPUs.

## Patches and mods

All are off at first start and are switched in the Xbox guide while playing
(Settings > Patches and Settings > Mods); the choice is saved.

| Name | Kind | What it does |
| --- | --- | --- |
| Unlock FPS | Patch | Up to 60 fps instead of 30. From Xenia Canary's game patches; Canary warns it can softlock certain missions ([RG-007-008](../docs/RG-007-008.md)). |
| Infinite Ammo | Mod | Firing sets the clip to 999 instead of using it up. |
| Infinite Grenades | Mod | Throwing sets grenades to 999. |
| God Mode | Mod | Bond's health is set to 30000 when he takes damage. |
| One-Hit Kills | Mod | Any hit on an enemy sets its health to 0. |

The mods are read from the Aurora trainer pack's trainer for this game, each
checked against this executable ([RG-007-010](../docs/RG-007-010.md)).

## Add-ons

Games & Apps > Manage Game in the Xbox guide lists the game's marketplace
add-on, **The Camille Map Pack** (four multiplayer maps), and installs it from
a package on your PC ([RG-007-012](../docs/RG-007-012.md)).

## Configuration

[`quantumofsolace.toml`](quantumofsolace.toml) is this game's codegen
configuration: the guest function entries the recompiler can't find on its
own ([RG-007-001](../docs/RG-007-001.md) to [RG-007-004](../docs/RG-007-004.md)),
the CRT `setjmp`/`longjmp` ([RG-007-007](../docs/RG-007-007.md)), the patches
and mods above, and the add-on list. Building is described in
[docs/building.md](../docs/building.md).

## Sources

- [LaunchBox Games Database](https://gamesdb.launchbox-app.com/games/details/11309-007-quantum-of-solace):
  release date, developers, rating.
- [x360db](https://github.com/xenia-manager/x360db/tree/main/titles/415607FF)
  (Xenia Manager's database): marketplace description and the banner above.
- The disc and its `default.xex` headers: everything under "The release this
  is built from".
