Unless mentioned otherwise:
- Use `jujutsu` (jj) for all version control operations. If a `jj` repo is not created yet, run `jj git init`.
- **Workflow:**
    - **Atomicity:** Always prefer atomic and small commits over single large ones. Leverage `jj`'s ability to easily manage stacks of revisions to keep changes focused and reviewable.
    - **Setup / Troubleshooting:**
        - If `jj git push` fails for `main`, run `jj bookmark track main --remote=origin`. This establishes the link between local `main` and `origin/main`, which might be missing after a fresh clone or if `main` was recreated manually.
    - **Default (Incremental Development):**
        1. Edit files for an atomic change.
        2. `jj describe` to set the commit message.
        3. `jj new` to start a new revision for the next atomic change.
        4. Repeat until the task is complete.
    - **Pushing Changes:** Only move the main bookmark and push when explicitly requested by the user:
        1. `jj bookmark set main -r @`
        2. `jj git push`
    - **Complex Features:** For experimental or risky changes, attach a specific bookmark (`jj bookmark set <name>`), push, and optionally create a PR (`gh pr create`).
    - **Stacked Changes:** This is the preferred workflow. Create chains of revisions for logical separation, ensuring each revision is atomic.
- **Safety & Standards:**
    - Always ask for confirmation before changing files.
    - You can always describe commits anytime, but you should always get confirmation before pushing to remote.
    - For complex changes, write a brief design doc or plan first.
    - Always format code using `nix fmt .`.
    - Do not merge PRs yourself.
    - When creating a GitHub pull request with `gh pr create`, always use explicit flags (e.g., `--head`, `--base`, `--title`, `--body` or `--body-file`) to ensure the command is non-interactive. For complex PR bodies, write the body to a temporary text file and use `--body-file`.