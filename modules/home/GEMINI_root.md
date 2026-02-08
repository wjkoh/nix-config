Unless mentioned otherwise:
- Use `jujutsu` (jj) for all version control operations. If a `jj` repo is not created yet, run `jj git init`.
- **Workflow:**
    - **Setup / Troubleshooting:**
        - If `jj git push` fails for `main`, run `jj bookmark track main --remote=origin`. This establishes the link between local `main` and `origin/main`, which might be missing after a fresh clone or if `main` was recreated manually.
    - **Default (Direct Push):**
        1. Edit files.
        2. `jj describe` to set the commit message.
        3. Move the main bookmark to the current revision: `jj bookmark set main -r @`.
        4. Push: `jj git push`.
    - **Complex Features:** For experimental or risky changes, attach a specific bookmark (`jj bookmark set <name>`), push, and optionally create a PR (`gh pr create`).
    - **Stacked Changes:** You may still create chains of revisions for logical separation, but prefer squashing or linearly updating `main` for simple tasks.
- **Safety & Standards:**
    - Always ask for confirmation before changing files.
    - For complex changes, write a brief design doc or plan first.
    - Always format code using `nix fmt .`.
    - Do not merge PRs yourself.
    - When creating a GitHub pull request with `gh pr create`, always use explicit flags (e.g., `--head`, `--base`, `--title`, `--body` or `--body-file`) to ensure the command is non-interactive. For complex PR bodies, write the body to a temporary text file and use `--body-file`.