Unless mentioned otherwise:

- **Version Control:** Use `jujutsu` (`jj`). Run `jj git init` if needed. Prefer small, atomic, stacked commits.
- **Workflow:**
  - **Stacking:** For each atomic change: edit files, set the message (`jj describe`), then start a new revision (`jj new`).
  - **Pushing:** *Only* update and push `main` when explicitly requested (`jj bookmark set main -r @ && jj git push`).
  - **Branches/PRs:** For risky changes, use a named bookmark, push, and create a PR. Do not merge PRs yourself.
  - **Troubleshooting:** If pushing `main` fails, link it: `jj bookmark track main --remote=origin`.

- **Safety & Standards:**
  - **Confirmations:** Always ask for confirmation before changing files or pushing code. 
  - **Formatting & Verification:** Format with `task fmt` if applicable. Verify changes by building or testing silently (e.g., `> /dev/null`) before passing control back.
  - **CLI Tools:** Use `gh pr create` non-interactively with explicit flags (e.g., `--title`, `--body-file`).
  - **Documentation:** Write a brief plan/design doc for complex changes first. Include the current date and time in all newly created Markdown or text files.
