---
name: print-package-info
description: Prints details for a built psibase package. Use when the user asks to inspect a built package, print package contents, or analyze a `.psi` by package name.
---

# Print Built Package Info

## Instructions

1. Run the script from the repository root with a package name:

   `bash .cursor/skills/print-package-info/scripts/print-package-info.sh <package-name>`

2. The script reads:

   `./build/psidk/share/psibase/packages/<package-name>.psi`

3. The script prints:
   - archive path and size,
   - extracted file tree,
   - each extracted file path with size.

