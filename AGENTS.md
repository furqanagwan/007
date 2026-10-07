# 007 development scope

Read `README.md`, `docs/building.md`, the assigned GitHub issue and the relevant
title evidence record before changing a game. Follow the SDK's architecture,
title-profile, provenance and regression policy for shared runtime changes.

Current work is limited to Quantum of Solace, Blood Stone and 007 Legends.
Do not expand validation to FIFA Street, NHL or original Xbox games without
a new owner request. Keep the existing Xbox 360 Guide for these Xbox 360 titles.

Normal launches and routine checks use borderless fullscreen, direct launch
and warnings/errors logging. Use `scripts/Launch-007.ps1`; users quit through
the Guide's Leave Game confirmation. Do not add a replacement host exit UI.
Do not remove Windows recovery shortcuts.

Run one candidate instance per routine check. Use paired previous/candidate
runs only when a specific change needs a regression comparison, and state why.
Diagnostic logging must be bounded to the failure being investigated. Preserve
small results, hashes and evidence notes; avoid accumulating verbose raw logs.
The owner requested removal of existing work logs on 2026-10-07; their old paths
in historical records no longer imply that those raw files are available.

Preserve game inputs, installed binaries, user profiles, saves and patch choices.
Use disposable save copies for regression and failure tests. Never commit game
files, generated game code, saves, private screenshots or raw runtime logs.

Prioritize bounded shared SDK fixes before title work. Run their affected
software tests per change, then batch generation (when codegen changed), builds
and title tests for these three games. Use PC GDK 260404; GDK-free builds in old
records are historical. Current SDK audit/queue:
https://github.com/furqanagwan/rexglue-sdk/pull/216.

The title acceptance issue remains `furqanagwan/007#16`: establish a repeatable
interactive Quantum of Solace checkpoint on the current build, then check
controller/keyboard input, gameplay, save/load and Guide exit. Consult the
existing save/load evidence in `docs/RG-007-007.md` before repeating old work.
Fullscreen is verified for all three current candidate titles. The 2026-10-07
automated Guide exit check passed for Blood Stone and Legends and was
inconclusive for Quantum of Solace; do not describe that as a proven defect.
