<p align="center">
  <a href="Quantum%20of%20Solace/README.md"><img src="assets/icons/quantumofsolace.png" width="96" alt="Quantum of Solace"></a>
  <a href="Blood%20Stone/README.md"><img src="assets/icons/bloodstone.png" width="96" alt="James Bond 007: Blood Stone"></a>
  <a href="Legends/README.md"><img src="assets/icons/legends.png" width="96" alt="007 Legends"></a>
</p>

# 007 — Xbox 360 recompilation

The three Xbox 360 James Bond games, rebuilt as native Windows games with
[ReXGlue](https://github.com/furqanagwan/rexglue-sdk). They build for **Xbox
on PC** and the **next-generation Xbox (Project Helix) app**, using Microsoft's
own Xbox 360 backward compatibility as the guide, Xbox 360 Guide included.

> [!IMPORTANT]
> No game files are included. You need your own copy of each game.

## The games

| Game | Status |
| --- | --- |
| [Quantum of Solace](Quantum%20of%20Solace/README.md) | In-game |
| [James Bond 007: Blood Stone](Blood%20Stone/README.md) | Investigating |
| [007 Legends](Legends/README.md) | Investigating |

**Investigating:** builds, but gameplay isn't confirmed. **In-game:** reaches
gameplay, not yet checked end to end. **Playable:** checked through the game.

## Play

1. Download a release from [Releases](https://github.com/furqanagwan/007/releases)
   (none published yet), or build it: [docs/building.md](docs/building.md).
2. Start the game and choose your disc image or game folder the first time.
3. Press View and Menu together (or Home) for the Xbox 360 Guide:
   achievements, settings, mods and Leave Game.

You need Windows 11 x64, a Direct3D 12 GPU (only NVIDIA tested so far) and an
Xbox controller.

## Repository layout

```text
<Game>/README.md   The game's page: disc, status, what works
<Game>/<name>.toml How ReXGlue recompiles that game
docs/              Building, and one record per issue (RG-007-NNN.md)
scripts/           Launcher
assets/            Artwork and each game's icon
```

Everything else (disc images, generated code, builds, saves, logs) stays on
your machine; `.gitignore` only lets the files above in.

## Contributing

Fixes that help every game go to
[rexglue-sdk](https://github.com/furqanagwan/rexglue-sdk); only what is
specific to these games belongs here. Work on a branch and open a pull
request; `main` only changes through reviewed PRs with a passing build.

## Legal

007, James Bond and the game titles are trademarks of their owners. This is
an independent preservation project, not affiliated with or endorsed by them
or by Microsoft. It contains no game code or game files. `assets/icons/` holds
each game's own title icon so the games can be recognised; the rest of
`assets/` is original.

## Credits

[ReXGlue](https://github.com/rexglue/rexglue-sdk),
[Xenia](https://github.com/xenia-project/xenia),
[Xenia Canary](https://github.com/xenia-canary/xenia-canary),
[Xenia Edge](https://github.com/has207/xenia-edge),
[LaunchBox Games Database](https://gamesdb.launchbox-app.com/) and
[x360db](https://github.com/xenia-manager/x360db).
