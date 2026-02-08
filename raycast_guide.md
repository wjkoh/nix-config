# Raycast Guide

Raycast is a highly extensible launcher for macOS that acts as a "Command Palette" for your entire operating system. It allows you to perform complex tasks without taking your hands off the keyboard.

## Key Use Cases

### 1. System Control (CLI for GUI)
*   **System Commands:** Quickly execute commands like `Empty Trash`, `Lock Screen`, `Restart`, `Sleep`, or toggle `Do Not Disturb`.
*   **Application Launching:** Replaces Spotlight for launching apps with fuzzy search.
*   **Window Management:** While AeroSpace handles tiling, Raycast is excellent for quick actions like "Center Window", "Maximize", or moving windows between displays if they misbehave.

### 2. Developer Utilities (Built-in)
*   **Clipboard History:** Access your clipboard history with a shortcut (often mapped to `Cmd+Shift+V` or a Hyper key combo). Search and paste previous clips.
*   **Snippets:** Create text expansions (e.g., type `;email` to paste your email address, or `;jira` to paste a ticket template).
*   **Floating Notes:** A "scratchpad" window that stays on top of other apps for quick temporary notes.
*   **Conversions & Math:** Type `100 USD to EUR`, `now in UTC`, or `128 * 45` directly in the search bar.
*   **Dev Tools:** Built-in tools to format JSON, decode Base64, generate UUIDs, and check color codes.

### 3. Extension Ecosystem
Raycast's store has hundreds of community extensions. Recommended for you:
*   **GitHub:** View PRs, issues, and notifications.
*   **Homebrew:** Search and install brew packages.
*   **Visual Studio Code:** Open recent projects directly.
*   **Docker:** View and manage running containers.
*   **Linear/Jira:** Create and search issues.

### 4. Script Commands
You can write custom scripts (Bash, Python, Swift, Node.js) that appear as commands in Raycast.
*   *Example:* A script to run `nix fmt .` or `jj git push` from the GUI.

## Installation
Raycast is best installed via Homebrew Cask or manual download, as it is a closed-source macOS application that auto-updates itself.


