---
name: rebuild-package-on-change
description: Rebuild the full psibase package (C++/wasm + UI assets) after edits to a psibase package UI or service. Use when a user changes files under `packages/**/<PackageName>/ui/` or `packages/**/<PackageName>/(src|include)/` and the change requires a full package rebuild (not only `*_js`).
---

# Rebuild Full Package After UI/Service Changes

## When to use
Use this skill when the agent makes changes to a specific psibase package’s UI (`ui/`) or service code (`src/`, `include/`, etc.).

## Determine the package target
Infer `PackageName` from the edited file path:
- If the path matches `packages/local/<PackageName>/...`, use `PackageName`
- If the path matches `packages/system/<PackageName>/...`, use `PackageName`
- If the path matches `packages/user/<PackageName>/...`, use `PackageName`
- Otherwise: ask the user which build target to rebuild.

## Build (from repo root)
Run:
```bash
cmake --build build -j 4 --target <PackageName>
```

## Important
- Do not build only the UI target (e.g. `XProxy_js`). The goal is to rebuild the entire package target so all generated assets are consistent.
- If the build command above fails (non-zero exit / CMake error) on the first attempt, do not retry blindly. Ask the user what build command/target they want you to run (and include the error details you saw).

