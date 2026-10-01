<p align="center"><img src="https://raw.githubusercontent.com/xenia-manager/x360db/main/titles/415608D8/artwork/banner.png" alt="007 Legends marketplace banner"></p>

# 007 Legends

The 2012 James Bond shooter, statically recompiled from its Xbox 360
executable into a native Windows PC game with
[ReXGlue](https://github.com/furqanagwan/rexglue-sdk).

Daniel Craig's Bond plays through classic missions from *Goldfinger*, *On Her
Majesty's Secret Service*, *Moonraker*, *Licence to Kill* and *Die Another
Day*, with gadgets and weapons to unlock and upgrade. A *Skyfall* mission
followed as a free add-on.

**Status: Investigating.** It recompiles and boots to its front end; play
through the missions hasn't been validated yet.

## The game

| | |
| --- | --- |
| Released | 16 October 2012 |
| Developer | Eurocom |
| Publisher | Activision |
| Genre | First-person shooter |
| Players | Single-player campaign; four-player split-screen; online multiplayer for up to 12 (Xbox Live, not available) |
| Rating | ESRB T (Teen) |

## The release this is built from

| | |
| --- | --- |
| Disc (Redump) | `007 Legends (USA, Europe) (En,Fr,De)`, one disc |
| Region | USA and Europe |
| Languages | English, French, German |
| Title ID | `415608D8` |
| Media ID | `5B1FDAF8` |
| Executable | `Default.xex` v4 |
| XEX SHA-256 | `8f63f536e615abafdcbe94aef5a369ae48357613e3f56e924230223f45891e76` |
| Title update | None. Xbox Unity lists no title update for this disc. |

Check that your disc's title and media IDs match: the recompiled code is only
valid for this executable.

## What works

Tested on an NVIDIA RTX 5080 Laptop GPU ([RG-007-006](../docs/RG-007-006.md)).

- **Recompiles** with codegen fixes made in the SDK for it (entries after
  called thunks, `ldbrx`/`stdbrx`, `vrlb`).
- **Boots to the front end:** 90-second GDK runs reach the animated front end
  with no error lines. A controller connects and XAudio2 plays.
- **Achievements:** the game's achievement pages read correctly from the SDK
  (it pages through them 25 at a time).

**Not validated yet:** playing through the missions, split-screen, saving and
loading, visual accuracy against a console, AMD and Intel GPUs, and the
standard (non-GDK) build.

## Mods

All are off at first start and are switched in the Xbox guide while playing
(Settings > Mods); the choice is saved. They're read from the Aurora trainer
pack's trainer for this game, each checked against this executable
([RG-007-010](../docs/RG-007-010.md)).

| Name | What it does |
| --- | --- |
| God Mode | Health is reset to its maximum instead of taking damage. |
| Infinite Ammo & No Reload | Ammunition isn't used up. |
| Infinite Clip | Firing sets the clip to 999. |
| Infinite & Max XP | XP reads as the maximum. |
| Infinite Time | Mission timers don't run down. |
| Max Score | The score reads as the maximum. |

## Cheat codes

The game's own codes, typed in at Extras > Cheat Codes. The Xbox guide lists
them under Settings > Cheats ([RG-007-011](../docs/RG-007-011.md)).

| Code | Unlocks |
| --- | --- |
| `f1n3att1r3` | James Bond (Jacket), in split-screen |
| `astr0b0y` | James Bond (Astronaut), in split-screen |
| `g3tb0nd` | 007 Pack: the Walther PPK in single-player and multiplayer, and the Fast Switch gadget in multiplayer |
| `m00nlas3r` | Moonraker Pack: the Moonraker Laser Mk2 in multiplayer |
| `au43v3r` | Goldfinger Pack: Goldfinger (Fort Knox) and Pussy Galore (Pilot) in multiplayer |
| `v00d00f1sh` | Nemesis Pack: Jaws (Astronaut) and Baron Samedi (Skeleton) in multiplayer |
| `qbranch3d` | Stealth Pack: the Long Reach and Acute Hearing gadgets in multiplayer |
| `l3g3nds` | Skyfall Pack: the Skyfall mission, Eve, Patrice, the Kowloon T-100 and the Tactical FSR in multiplayer |

## Add-ons

Games & Apps > Manage Game in the Xbox guide lists the game's marketplace
add-ons, the **SKYFALL Content Pack** (free) and the **Eve** and **Patrice**
character skins, and installs them from packages on your PC
([RG-007-012](../docs/RG-007-012.md)).

## Configuration

[`legends.toml`](legends.toml) is this game's codegen configuration: the mods,
cheat codes and add-on list above. Building is described in
[docs/building.md](../docs/building.md).

## Sources

- [LaunchBox Games Database](https://gamesdb.launchbox-app.com/games/details/12289-007-legends):
  release date, developer, players, rating, missions.
- [x360db](https://github.com/xenia-manager/x360db/tree/main/titles/415608D8)
  (Xenia Manager's database): marketplace description and the banner above.
- The disc and its `Default.xex` headers: everything under "The release this
  is built from".
