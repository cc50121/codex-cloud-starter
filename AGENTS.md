# Repository guidance

This repository is designed for both Codex Cloud and GitHub Codespaces.

## Before changing code

- Read `README.md` and the relevant dependency manifests before editing.
- Inspect `git status` and preserve unrelated user changes.
- Never commit credentials, `.env` files, tokens, or Codex authentication caches.
- Use the package manager selected by the existing lockfile. Do not replace lockfiles unless the task requires it.

## Implementation expectations

- Prefer small, reviewable changes over broad rewrites.
- Keep setup reproducible from a fresh checkout.
- When adding a runtime dependency, update both its manifest and lockfile.
- Add or update tests for behavior changes.
- Document any new required environment variable in `.env.example` without adding a real value.

## Verification

- Run `bash scripts/check.sh` before handing off changes.
- If the script does not cover a project-specific command, run that command explicitly and add it to this file.
- Report commands that were run and any checks that could not run.

## Project-specific notes

Replace this section after creating a project from the template. Record the architecture, important directories, development commands, and acceptance checks that future Codex tasks should follow.

