Unless mentioned otherwise:

- **Environment & Context:**
  - **Environment:** Assume the environment is managed by Nix and `direnv`. If a tool is missing, suggest adding it to the relevant `flake.nix` devShell rather than using system-wide package managers.
  - **Project Context:** Always read `README.md` and `Taskfile.yml` (if present) when entering a new directory to understand the local build/test commands before taking action.

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
  - **Shell Aliases:** The user has numerous aliases set up (e.g., `cat` -> `bat`, `man` -> `tldr`, `ssh` -> `autossh -M 0` are just a few). You must use the `command` prefix ALL THE TIME when executing standard shell commands to ensure you bypass these aliases (e.g., `command cat file.txt`, `command man ls`, `command ssh ...`).
  - **Documentation:** Write a brief plan/design doc for complex changes first. Include the current date and time in all newly created Markdown or text files.
