<p align="center"><img src="https://raw.githubusercontent.com/xenia-manager/x360db/main/titles/4156081F/artwork/banner.png" alt="James Bond 007: Blood Stone marketplace banner"></p>

# James Bond 007: Blood Stone

The 2010 James Bond third-person shooter, statically recompiled from its Xbox
360 executable into a native Windows PC game with
[ReXGlue](https://github.com/furqanagwan/rexglue-sdk).

An original Bond story by screenwriter Bruce Feirstein, with the likeness and
voices of Daniel Craig, Joss Stone and Judi Dench. A stolen bio-chemical
weapon leads Bond through Athens, Istanbul, Monaco and Bangkok, in cover-based
firefights, hand-to-hand combat and driving chases.

**Status: Investigating.** It recompiles and boots to its front end; starting
a mission hasn't been validated yet.

## The game

| | |
| --- | --- |
| Released | 2 November 2010 (North America), 5 November 2010 (Europe) |
| Developer | Bizarre Creations |
| Publisher | Activision |
| Genre | Third-person shooter, stealth, driving |
| Players | Single-player campaign; online multiplayer for up to 16 (Xbox Live, not available) |
| Rating | ESRB T (Teen) |

## The release this is built from

| | |
| --- | --- |
| Disc (Redump) | `007 - Blood Stone (USA, Europe) (En,Fr,De)`, one disc |
| Region | USA and Europe |
| Languages | English, French, German |
| Title ID | `4156081F` |
| Media ID | `42DBE473` |
| Executable | `default.xex` v2 |
| XEX SHA-256 | `c411c4c81d81cd4bc06de4ea2bc0866a7741c44f7108451ca14fc6be5d1ac4b0` |
| Title update | None applied. Title update 1 exists for this disc (on Xbox Unity); title update support is in progress in the SDK ([rexglue-sdk#153](https://github.com/furqanagwan/rexglue-sdk/issues/153)). |

Check that your disc's title and media IDs match: the recompiled code is only
valid for this executable.

## What works

Tested on an NVIDIA RTX 5080 Laptop GPU ([RG-007-006](../docs/RG-007-006.md)).

- **Recompiles without title hints.**
- **Boots to the front end:** 90-second GDK runs reach the animated front end
  with no error lines. A controller connects and XAudio2 plays.
- **The first level** was reached in an SDK test run, rendering correctly at
  30 fps once resolve readback became the default (it was almost white
  before; [SDK record](https://github.com/furqanagwan/rexglue-sdk/blob/main/docs/upstream-tracking.md#resolve-readback-on-by-default-2026-09-29)).
  There is no record of play beyond it yet.

**Not validated yet:** starting and finishing missions, saving and loading,
visual accuracy against a console, AMD and Intel GPUs, and the standard
(non-GDK) build.

## Configuration

[`bloodstone.toml`](bloodstone.toml) is this game's codegen configuration.
Blood Stone needs no title-specific settings yet, so it only identifies the
executable. Building is described in [docs/building.md](../docs/building.md).

## Sources

- [LaunchBox Games Database](https://gamesdb.launchbox-app.com/games/details/13199-007-blood-stone):
  release dates, developer, rating, story credits.
- [x360db](https://github.com/xenia-manager/x360db/tree/main/titles/4156081F)
  (Xenia Manager's database): marketplace description and the banner above.
- The disc and its `default.xex` headers: everything under "The release this
  is built from".
