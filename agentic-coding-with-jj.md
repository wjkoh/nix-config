# Stop Using Git for Agentic Coding

**Modern problems require modern solutions.**

In the era of AI-driven development, our tools need to evolve. We are still forcing our autonomous coding agents to use Git—a tool designed for human constraints, manual staging, and rigid history. It's time to stop.

If you are building or using AI coding agents, **Git is holding you back.** The answer is **Jujutsu (`jj`)**.

## Why Git Fails Agents

Git assumes a human is painstakingly crafting every commit. It punishes you for changing your mind.
- **Rewriting history is dangerous:** `git rebase` is a minefield of conflicts and detached HEAD states.
- **Context switching is expensive:** Switching branches changes the filesystem, confusing agents that rely on file state.
- **Conflict resolution is blocking:** A merge conflict stops the world. The agent has to fix it *right now* before it can do anything else.

## Why Jujutsu (`jj`) is the "Agent-Native" VCS

Jujutsu is a Git-compatible VCS that fixes the fundamental data model issues that plague agentic workflows.

### 1. Agents Can "Time Travel" Safely
In `jj`, **commits are mutable by default.** An agent can make a change, realize it broke something 3 commits ago, go back, edit *that* commit, and `jj` automatically rebases everything on top.
- **Git:** `git rebase -i HEAD~3` -> *Conflict Hell* -> *Agent Crash*
- **jj:** `jj edit @---` -> *Fix* -> `jj edit @+++` -> *Done.*

### 2. Conflicts Are First-Class Citizens
This is the killer feature. In `jj`, **conflicts can be committed.**
If an agent merges two branches and creates a conflict, `jj` doesn't scream and abort. It records the conflict in the file (like standard conflict markers) and *lets you keep working*.
The agent can resolve the conflict in a later step, or even in a different commit. It never gets "stuck" in a merge state.

### 3. The "Stacked PR" Workflow
Agents work fastest when they can break big tasks into small, dependent chunks.
- Feature A (Backend)
- Feature B (Frontend, depends on A)
- Feature C (Docs, depends on B)

In Git, managing this stack is a nightmare of rebasing. In `jj`, it's the default way of working. You just keep adding commits. If you change Feature A, `jj` automatically propagates the changes to B and C.

---

## The Workflow: A Practical Guide for Agents

Here is how an Agent (or you) should actually work with `jj`.

### 1. Setup: Colocated with Git
You don't need to ditch your GitHub repo. Initialize `jj` inside your existing git repo. It keeps the `.git` folder in sync.

```bash
# Initialize jj in "colocated" mode
jj git init --colocate
```

Now you can use `jj` commands locally, and `git push` works as usual (or use `jj git push`).

### 2. The Loop: Stacked Commits
Forget `git add` and `git commit`. Just work.

**Scenario:** Building a Feature with a dependency.

```bash
# 1. Start a new change (creates an empty commit on top of current)
jj new -m "feat: backend api"

# ... Agent writes code ...
# (No need to 'add' files, jj tracks the working copy automatically)

# 2. Start the NEXT change immediately
jj new -m "feat: frontend ui"

# ... Agent writes UI code that uses the API ...
```

At this point, you have a stack: `main` -> `backend` -> `frontend`.

### 3. Going Back to Fix (Time Travel)
The Agent realizes the backend API is missing a field.

```bash
# Jump back to the backend commit
jj edit "feat: backend api"  # or use rev ID

# ... Agent fixes the API ...

# Jump back to the tip (frontend)
jj edit "feat: frontend ui"
```
**Magic:** `jj` automatically rebased the frontend commit on top of the fixed backend. No commands needed.

### 4. Shipping: Stacked GitHub PRs
To get this on GitHub, we bridge the gap between `jj` stacks and Git branches.

```bash
# 1. Assign "Bookmarks" (Git branches) to your commits
jj bookmark create feat/backend -r @-
jj bookmark create feat/frontend -r @

# 2. Push them to GitHub
jj git push --bookmark feat/backend
jj git push --bookmark feat/frontend
```

Now, create the PRs using the GitHub CLI (`gh`). **Crucial Step:** Chain the bases.

```bash
# PR 1: Backend -> Main
gh pr create --head feat/backend --base main --title "feat: backend"

# PR 2: Frontend -> Backend (Stacked!)
gh pr create --head feat/frontend --base feat/backend --title "feat: frontend"
```

### 5. The Merge & Rebase Dance
This is where standard Git workflows break down, but `jj` shines.

**Scenario:** You merge PR 1 (`backend`) into `main` on GitHub.

1.  **Fetch:** `jj git fetch`
    *   `jj` sees `main` moved forward.
    *   `jj` sees your local `feat/backend` is now "divergent" (it's in `main` now).

2.  **Rebase:** Move your remaining work (`frontend`) onto the new `main`.
    ```bash
    jj rebase -b feat/frontend -d main@origin
    ```
    *   `jj` detects the `backend` changes are already in `main` and "abandons" the duplicate backend commit.

3.  **Cleanup:**
    ```bash
    jj bookmark delete feat/backend
    ```

You are now left with a clean state: `main` -> `frontend`.

## Pro-Tips: Making `jj` Effortless

While `jj` is powerful, knowing its native commands turns it into a high-performance engine.

### 1. Recommended Configuration
To make `jj` behave like a true time-travel machine (editing commits by default instead of branching), add this to your config:

```toml
[ui]
movement.edit = true  # 'jj prev' and 'jj next' will edit commits
```

### 2. Powerful Built-ins You Should Know
Jujutsu comes with some life-saving commands right out of the box:

- **`jj log`**: The most important command. It shows the commit graph (the stack). Use `jj log -r ..` to see specific ranges.
- **`jj undo`**: The ultimate safety net. It undoes the last `jj` operation, no matter how complex.
- **`jj diff`**: Shows changes in the current working copy.
- **`jj status`**: Summary of the working copy state.
- **`jj squash`**: Moves changes from the working copy into the parent commit. Essential for cleaning up stacks.
- **`jj edit`**: The primary way to navigate. `jj edit @-` moves to the parent, `jj edit @+` moves to the child.
- **`jj prev`**: Moves the working copy to the parent commit. (Note: Creates a new head unless `ui.movement.edit = true` is set, or you use `jj prev --edit`).
- **`jj next`**: Moves the working copy to the child commit.
- **`jj new`**: Creates a new empty commit on top of the current one.
- **`jj describe`**: Updates the description (commit message) of the current change.

### 2. The TUI Experience: Visualizing the Stack

If you prefer seeing your commit graph, these two tools are game-changers:

- **[lazyjj](https://github.com/Cretezy/lazyjj):** Built for speed. It mimics the popular `lazygit` but for `jj`.
    - **Best for:** Fast navigation, squashing commits with one key, and managing bookmarks without typing.
    - **Key Bindings:** `J/K` to navigate stack, `s` to squash, `b` to bookmark.

- **[jjui](https://github.com/idursun/jjui):** A robust, dedicated UI.
    - **Best for:** Detailed diff inspection and understanding complex graph divergences.
    - **Visuals:** Provides a clean split-view of the graph and the diff.

*Tip: AI agents can also be trained to read the output of `jj log` or interact with these TUIs to better understand the codebase history.*

---

## The New Standard

We are moving from "Human writes code, commits to Git" to "Agent iterates on logic, manages state in Jujutsu."

If you want your AI engineer to be truly autonomous, give it a tool that forgives mistakes and encourages iteration. **Give it Jujutsu.**
