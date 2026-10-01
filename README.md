<p align="center">
  <a href="Quantum%20of%20Solace/README.md"><img src="assets/icons/quantumofsolace.png" width="96" alt="Quantum of Solace"></a>
  <a href="Blood%20Stone/README.md"><img src="assets/icons/bloodstone.png" width="96" alt="James Bond 007: Blood Stone"></a>
  <a href="Legends/README.md"><img src="assets/icons/legends.png" width="96" alt="007 Legends"></a>
</p>

# 007 — Xbox 360 recompilation

The Xbox 360 James Bond games, statically recompiled into native Windows PC
games with [ReXGlue](https://github.com/furqanagwan/rexglue-sdk): Direct3D 12
graphics, controller and audio support, achievements, and the Xbox 360 guide
built in.

> [!IMPORTANT]
> This repository contains no game files. You need your own legally obtained
> copy of each game: the disc listed on its page, as an ISO or its extracted
> files.

## The games

| Game | Released | Status |
| --- | --- | --- |
| [Quantum of Solace](Quantum%20of%20Solace/README.md) | 2008 · Treyarch | **In-game** |
| [James Bond 007: Blood Stone](Blood%20Stone/README.md) | 2010 · Bizarre Creations | **Investigating** |
| [007 Legends](Legends/README.md) | 2012 · Eurocom | **Investigating** |

Each game's page has its details, the exact disc it's built from, what works,
and its mods, cheat codes and add-ons.

**Status levels:**

- **Investigating:** recompiles, but doesn't reach gameplay yet, or hasn't
  been recorded doing so.
- **In-game:** reaches gameplay, but hasn't been validated end to end.
- **Playable:** validated through the game, within the limits listed.

## Download

No release has been published yet; the
[Releases](https://github.com/furqanagwan/007/releases) page will have them.
Until then, the games are built from source: see
[docs/building.md](docs/building.md).

## How to play

**You need:**

- Windows 11 x64 and a Direct3D 12 GPU. Only NVIDIA has been tested so far.
- Your own copy of the game, matching the disc on its page.
- A controller: Xbox controllers work through GameInput or XInput. Keyboard
  play hasn't been confirmed.

**Playing:**

- Start the game's executable with its game files (see
  [docs/building.md](docs/building.md#run-it) for the options).
- Open the **Xbox guide** with View and Menu together (Back and Start on an
  Xbox 360 pad) or the Home key. It has the game's achievements, its add-ons
  (Games & Apps > Manage Game), the mods and patches you can switch on while
  playing (Settings > Mods and Settings > Patches), the game's cheat codes,
  and Leave Game.
- Saves are kept per user, as on the console.

## Issues and records

- **Problems and progress** are tracked as
  [issues](https://github.com/furqanagwan/007/issues) with IDs `RG-007-NNN`;
  each has a record in [docs/](docs/README.md) with the tested executable's
  hashes, the SDK commit, the hardware, and what was and wasn't checked.
- **Where fixes go:** fixes that help every game go to
  [rexglue-sdk](https://github.com/furqanagwan/rexglue-sdk). Only what's
  specific to one of these games belongs here.

## Repository layout

```text
Quantum of Solace/   README.md and quantumofsolace.toml (codegen configuration)
Blood Stone/         README.md and bloodstone.toml
Legends/             README.md and legends.toml
docs/                building.md, and one record per issue (RG-007-NNN.md)
assets/              Original artwork (logo, social preview); icons/ holds each
                     game's title icon, as its window shows it
```

Everything else in a game's folder (disc images, extracted files, generated
code, builds, saves, logs) stays on your machine: `.gitignore` is an
allowlist. This repository follows the SDK's
[title repository standard](https://github.com/furqanagwan/rexglue-sdk/blob/main/docs/title-repo-standard.md).

## Legal

007, James Bond and the game titles are trademarks of their respective owners.
This is an independent preservation and research project, not affiliated with
or endorsed by them. It contains no game code or game files. The artwork in
`assets/` is original, except `assets/icons/`: each game's own title icon
(its XDBF title image, the icon its window and taskbar button show), so the
games can be recognised. The banners on the game pages are linked from the
[x360db](https://github.com/xenia-manager/x360db) database, not stored here.

## Credits

- [ReXGlue](https://github.com/rexglue/rexglue-sdk), the static recompilation
  SDK this builds on, and its authors.
- [Xenia](https://github.com/xenia-project/xenia),
  [Xenia Canary](https://github.com/xenia-canary/xenia-canary) and
  [Xenia Edge](https://github.com/has207/xenia-edge), whose Xbox 360 research
  the runtime draws on.
- [LaunchBox Games Database](https://gamesdb.launchbox-app.com/) and
  [x360db](https://github.com/xenia-manager/x360db) for the game details on
  each page.
