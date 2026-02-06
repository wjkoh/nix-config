# Unified Nix Config for NixOS and macOS

## 1. Overview

The goal of this repository is to manage distinct systems using a single Git
repository and Flake:

1. **MacBook Pro 14 (macOS):** Hostname `mbp-14`. Uses **nix-darwin** for
   system-level configuration (including hostname management) and Home Manager
   (as a module) for user tools and dotfiles.
2. **HP Z2 Mini G1a (NixOS):** Hostname `z2-mini`. Uses NixOS for system
   configuration and Home Manager (as a module) for user configuration.

**Key Philosophy:** "Write once, run everywhere" for user tools (Neovim, Zsh,
Git, etc.), while keeping system-specific configurations (disk mounts,
networking, macOS settings) separate.

## 2. Directory Structure

This repository uses a modular structure to maximize code reuse:

```text
.
├── .envrc                   # Direnv configuration (auto-loads dev shell)
├── lefthook.yml             # Git hooks (formatting, linting)
├── flake.nix                # Entry point for all systems
├── flake.lock
├── modules/
│   └── home/
│       ├── default.nix      # Imports all common modules
│       ├── core.nix         # Shells, Git, common packages
│       ├── neovim.nix       # Neovim config
│       └── gui.nix          # GUI tools (Ghostty, etc.)
├── hosts/
│   ├── mbp-14/              # macOS specific configs (MacBook Pro 14)
│   │   ├── configuration.nix# System-level config (nix-darwin)
│   │   └── home.nix         # macOS-specific home overrides
│   └── z2-mini/             # NixOS specific configs (HP Z2 Mini G1a)
│       ├── configuration.nix# System-level config
│       ├── hardware-configuration.nix
│       └── home.nix         # NixOS-specific home overrides
```

## 3. Architecture & Implementation

### The Flake (`flake.nix`)

The `flake.nix` produces two types of outputs:

- `nixosConfigurations`: For the `z2-mini` machine.
- `darwinConfigurations`: For the `mbp-14` machine.

**Concept:**

- **Shared Inputs:** Both systems share `nixpkgs` versions via `flake.lock`.
- **NixOS (`z2-mini`):** Implements Home Manager as a system module for atomic
  updates.
- **macOS (`mbp-14`):** Implements nix-darwin with Home Manager as a system
  module for atomic updates.

### Shared Configuration (`modules/home/`)

- **`modules/home/core.nix`**: Contains the bulk of user configuration
  (Packages, Shells, Git, etc.).
- **Host Specifics**: `home.username` and `home.homeDirectory` are defined in
  `hosts/<machine>/home.nix` to allow portability.

## 4. Security & Authentication

- **[YubiKey SSH Guide](yubikey.md)**: Instructions for setting up FIDO2-based
  SSH authentication for passwordless, secure access to remote machines.

## 5. Agentic Workflows

- **[Stop Using Git for Agentic Coding](agentic-coding-with-jj.md)**: Why
  Jujutsu (`jj`) is the superior version control system for autonomous AI
  agents and how to use it effectively.

## 6. Workflow

### Updating mbp-14 (MacBook Pro)

Use `darwin-rebuild` to update both system and user configurations.

```bash
# From local source
$ sudo darwin-rebuild switch --flake .#mbp-14

# Directly from GitHub (useful for bootstrapping)
$ sudo nix run nix-darwin -- switch --flake github:wjkoh/nix-config#mbp-14
```

### Updating z2-mini (HP Z2 Mini)

```bash
# From local source
$ sudo nixos-rebuild switch --flake .#z2-mini

# Directly from GitHub
$ sudo nixos-rebuild switch --flake github:wjkoh/nix-config#z2-mini
```

## 6. Benefits

1. **Single Source of Truth:** Change configuration once, propagate to all
   machines.
2. **Shared Lockfile:** Ensures identical tool versions across macOS and Linux.
3. **Atomic Updates:** On NixOS, system and user configs update synchronously.

## 7. Post-Installation Steps

After applying the configuration, some manual steps are required:

### Tailscale

- **macOS (`mbp-14`):** Tailscale is installed automatically via the Mac App Store.
  Open the app to authenticate.
- **NixOS (`z2-mini`):** Tailscale is managed as a system service. Run
  `sudo tailscale up` to authenticate.

### Google Cloud SDK

On both systems, you must authenticate manually to use `gcloud` and application
default credentials:

```bash
$ gcloud auth login
$ gcloud auth application-default login
```

## 8. Key Tools & Aliases

To enhance productivity, several modern CLI replacements and aliases are
configured:

| Command | Alias To | Description                                                 |
| :------ | :------- | :---------------------------------------------------------- |
| `man`   | `tldr`   | Displays concise cheat sheets instead of full manuals.      |
| `df`    | `duf`    | Disk Usage/Free - a better `df` with colors and graphs.     |
| `du`    | `gdu`    | Disk Usage Analyzer - a fast, interactive `du` alternative. |
| `cat`   | `bat`    | A `cat` clone with syntax highlighting and Git integration. |
| `ls`    | `eza`    | A modern, maintained replacement for `ls`.                  |

### Zellij Auto-Start (Remote)

On `z2-mini`, Zellij is configured to start automatically upon SSH login to
ensure persistent sessions.

**Escape Hatch:** If you need to bypass Zellij (e.g., if it's crashing or you
need a clean shell), use the following command to log in:

```bash
ssh -t z2-mini "ZELLIJ=1 zsh -l"
```

> **Note:** The original commands are available via standard paths or by
> unaliasing if strictly needed.

## 9. CI & Enforcement

### Git Hooks (Lefthook)

This repository uses [Lefthook](https://github.com/evilmartians/lefthook) for
git hooks to ensure code quality. We chose Lefthook (over pre-commit) and
markdown-oxide (over marksman) to avoid introducing Python or .NET dependencies
into the environment. The hooks run automatically inside the development shell:

- **Pre-commit**:
  - `nix-fmt`: Formats all `.nix` files using `alejandra`.
  - `check-yaml`: Lints all YAML files.
- **Pre-push**:
  - `nix-flake-check`: Runs `nix flake check` to enforce dependency constraints.

### Dependency Enforcement

To keep the system minimal, we strictly enforce that **no `.NET` runtime
(dotnet)** is included in the system closure. This is checked automatically via
`nix flake check` (which runs on `git push`).

To verify manually:

```bash
$ nix flake check
```

If `dotnet` is found in the dependency graph, the check will fail and print the
dependency path.

