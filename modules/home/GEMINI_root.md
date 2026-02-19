Unless mentioned otherwise:

- **Version Control:** Use `jujutsu` (jj) for all operations. If a `jj` repo is
  not created yet, run `jj git init`.
- **Atomicity:** Always prefer atomic and small commits over single large ones.
  Leverage `jj`'s ability to easily manage stacks of revisions to keep changes
  focused and reviewable.

- **Workflow:**
  - **Standard Loop (Incremental Stacking):**
    1. Edit files for a single atomic change.
    2. `jj describe` to set the commit message.
    3. `jj new` to start a new revision for the next change.
    4. Repeat until the task is complete.
  - **Pushing Changes:** Only move the main bookmark and push when **explicitly
    requested** by the user:
    1. `jj bookmark set main -r @`
    2. `jj git push`
  - **Complex/Experimental Features:** For risky changes, attach a specific
    bookmark (`jj bookmark set <name>`), push, and optionally create a PR
    (`gh pr create`).
  - **Troubleshooting:**
    - If `jj git push` fails for `main`, run
      `jj bookmark track main --remote=origin`. This establishes the missing
      link between local `main` and `origin/main`.

- **Safety & Standards:**
  - **Confirmations:** Always ask for confirmation before changing files. You
    can `jj describe` and `jj new` anytime, but **must** get confirmation before
    pushing.
  - **Planning:** For complex changes, write a brief design doc or plan first.
  - **Formatting & Verification:** Always format code using `nix fmt .`. Additionally, if a `Taskfile.yml` is present, run `task fmt` (if available). After making any code changes, you must build the executable (directing the output to `/dev/null` or `/tmp` to avoid clutter) or run relevant tests to verify the changes *before* passing control back to the user.
  - **PRs:** Do not merge PRs yourself.
  - **Non-Interactive PR Creation:** When using `gh pr create`, always use
    explicit flags (e.g., `--head`, `--base`, `--title`, `--body` or
    `--body-file`) to ensure the command is non-interactive. For complex PR
    bodies, write the body to a temporary text file and use `--body-file`.
  - **Timestamps:** Whenever you create a new document, Markdown (`.md`) file, or similar text file, you must include the current date and time in the document so it is clear when it was written.
