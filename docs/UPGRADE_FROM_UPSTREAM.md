# Upgrading this fork from Microsoft upstream

This fork is based on [microsoft/monaco-editor](https://github.com/microsoft/monaco-editor) at **v0.52.2** (commit `404545b`).

## Start from scratch (base off v0.52.2)

To make this repo exactly Microsoft’s v0.52.2 plus the fork overlay:

1. Add upstream and fetch:
   `git remote add upstream https://github.com/microsoft/monaco-editor.git` (if needed), then
   `git fetch upstream tag v0.52.2`
2. Point your branch at upstream v0.52.2:
   `git checkout -B your-branch 404545b`
   (or use the tag: `git checkout -B your-branch v0.52.2` after fetching)
3. Apply fork-only changes: ensure **package.json** has `name` `@outsystems/monaco-editor` and `version` e.g. `0.52.2-os1`, and that **docs/UPGRADE_FROM_UPSTREAM.md** and **scripts/upgrade-from-upstream.sh** are present.
4. Run `npm install` and `npm run build`. If the build fails, do not change `build/` or `src/`; ask instead.

## Fork-only changes

- **package.json**: `name` is `@outsystems/monaco-editor`, `version` uses an `-osN` suffix (e.g. `0.52.2-os1`). All other fields (scripts, devDependencies, vscodeRef, etc.) follow upstream.
- **docs/UPGRADE_FROM_UPSTREAM.md**: This file.
- **scripts/upgrade-from-upstream.sh**: Script to merge a chosen upstream tag into the current branch.

We do **not** modify Microsoft’s build or source code (`build/`, `src/`) in this repo. If the build fails (e.g. TypeScript or Node version issues), do not change `build/` or `src/` without discussion.

## How to upgrade from upstream

1. Run from the repo root:
   ```bash
   ./scripts/upgrade-from-upstream.sh
   ```
2. If there are merge conflicts:
   - **package.json**: Keep our `name` (`@outsystems/monaco-editor`) and `version` (e.g. `0.52.2-os2`), take the rest from upstream (scripts, devDependencies, vscodeRef, etc.).
   - **package-lock.json**: `git checkout --theirs package-lock.json`, then run `npm install`.
   - Stage and commit: `git add . && git commit --no-edit`.
3. Run `npm install` and then `npm run build`. If the build fails, see the note above about not editing build/source code without discussion.

## Base reference

- Upstream: https://github.com/microsoft/monaco-editor
- Tag: **v0.52.2**
- Commit: **404545b**
