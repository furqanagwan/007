# 007 recompiled game projects

This repository tracks project-owned compatibility work and documentation for the 007 titles. Game images, extracted content, generated code, binaries, saves, and test logs remain local and must not be committed.

The first investigation uses Quantum of Solace. SDK-wide fixes belong in [rexglue-sdk](https://github.com/furqanagwan/rexglue-sdk); title-specific work belongs here. The root cause of the current boot failure is still being investigated.

For the tested Quantum of Solace XEX, add `../../configs/quantumofsolace.toml` to
the private `recompiled/quantumofsolace_manifest.toml` entrypoint `includes`
array before regenerating. The path is relative to that private manifest. This
adds a missing guest function entry without modifying game data. Use the SDK
codegen build containing [rexglue-sdk PR #31](https://github.com/furqanagwan/rexglue-sdk/pull/31).
The exact evidence and remaining boot failure are in [RG-007-001](docs/RG-007-001.md).
