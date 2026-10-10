# Repository notes

Add only original, redistributable project configuration and documentation after review. Keep all title assets and generated game output outside version control.

## Layout change (RG-007-013)

Each game's configuration moved from `configs/` into its own folder
(`Quantum of Solace/quantumofsolace.toml`, `Blood Stone/bloodstone.toml`,
`Legends/legends.toml`), next to its README. `configs/quantumofsolace-60fps.toml`
was removed: it only switched on the "Unlock FPS" patch at first start, and that
patch is switchable in the Xbox guide. Records before RG-007-013 keep the old
paths as they were written.

Building is described in [building.md](building.md).

Pull requests run the **Documentation and TOML** check. It parses every tracked
`.toml` and verifies local Markdown link targets, including encoded paths and
HTML artwork links. External URLs and fragment anchors are not fetched or
validated. Game inputs and generated files are excluded by using Git's tracked
file list. Run it locally with Python 3.11 or newer:

```powershell
python -m unittest discover -s scripts/tests -v
python scripts/check_repository.py
```

The current 007-only scope, fullscreen checks, log cleanup and next issue are
recorded in [the 2026-10-07 session](session-20261007.md).
