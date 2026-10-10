# Changelog

All notable changes to the 007 releases. The format follows
[Keep a Changelog](https://keepachangelog.com), and versions follow
[Semantic Versioning](https://semver.org): `0.x.y-alpha.N` while the games
are in alpha.

## [0.1.0-alpha.2] - 2026-10-10

### All games

- **Game Update.** Games & Apps > Game Update in the Guide checks for a newer
  release of your game, shows what changed and installs it in place. Saves
  and settings are kept.
- **Choose where the sound plays.** Settings > Preferences > Audio Output
  lists your PC's outputs, and the sound moves as soon as you choose one. The
  panel shows what the output supports: speakers, whether the game plays in
  5.1 or stereo there, spatial sound, and Dolby and DTS decoding.
- **Choose which monitor the game is on.** Settings > Preferences > Display
  moves the game to another monitor straight away. The panel shows the
  monitor's resolution, fastest refresh rate and HDR support.
- Guide fixes on 4K screens: radio buttons are sharp, the letters on the
  A and B buttons are centred, and the thin white line above the Guide is
  gone.
- The Games & Apps menu scrolls, so its last entries are reachable.
- A damaged disc image or game file is refused instead of crashing the
  game.

### Known issues

- Short stutters the first time new effects appear, while their shaders are
  prepared. They don't come back on later runs.
- Only tested on NVIDIA GPUs so far.
- Online multiplayer isn't included.
- Title updates are listed in the Guide but can't be applied yet.

## [0.1.0-alpha.1] - 2026-10-09

First public alpha. Expect bugs; your saves are kept outside the game folder,
so updating or deleting a release never touches them.

### All games

- Native Windows x64 builds of the three Xbox 360 Bond games, made with
  [ReXGlue](https://github.com/furqanagwan/rexglue-sdk).
- No game files included: on first run, pick your own disc image (`.iso`) or
  game folder in the Xbox 360 Guide-style picker.
- The Xbox 360 Guide is built in (View + Menu, or the Xbox button):
  achievements, settings, Leave Game.
- Achievements unlock and show the Xbox 360 notification.
- Saves go to `Saved Games\<game>`; settings, logs and caches to
  `%LOCALAPPDATA%\<game>`.

### Quantum of Solace

- Status: **In-game**. Reaches and plays missions; a full playthrough hasn't
  been checked.
- Fixed: the picture froze when an achievement unlocked
  ([rexglue-sdk#223](https://github.com/furqanagwan/rexglue-sdk/pull/223)).

### James Bond 007: Blood Stone

- Status: **Investigating**. Boots, reaches its first level and renders it;
  play beyond that isn't confirmed. Runs at the game's own 30 fps cap.

### 007 Legends

- Status: **Investigating**. Boots and plays its in-engine opening; play
  beyond that isn't confirmed.

### Known issues

- Short stutters the first time new effects appear, while their shaders are
  prepared. They don't come back on later runs.
- Only tested on NVIDIA GPUs so far.
- Online multiplayer isn't included.
- Title updates are listed in the Guide but can't be applied yet.
