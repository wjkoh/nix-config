# Unified Nix Config for NixOS and macOS

## 1. Overview
The goal of this repository is to manage distinct systems using a single Git repository and Flake:
1.  **MacBook Pro 14 (macOS):** Hostname `mbp-14`. Uses Home Manager (standalone) to manage user tools and dotfiles.
2.  **HP Z2 Mini G1a (NixOS):** Hostname `z2-mini`. Uses NixOS for system configuration and Home Manager (as a module) for user configuration.

**Key Philosophy:** "Write once, run everywhere" for user tools (Neovim, Zsh, Git, etc.), while keeping system-specific configurations (disk mounts, networking, macOS settings) separate.

## 2. Directory Structure

This repository uses a modular structure to maximize code reuse:

```text
.
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
│   │   └── home.nix         # macOS-specific home overrides
│   └── z2-mini/             # NixOS specific configs (HP Z2 Mini G1a)
│       ├── configuration.nix# System-level config
│       └── hardware-configuration.nix
```

## 3. Architecture & Implementation

### The Flake (`flake.nix`)

The `flake.nix` produces two types of outputs:
*   `nixosConfigurations`: For the `z2-mini` machine.
*   `homeConfigurations`: For the `mbp-14` machine.

**Concept:**
*   **Shared Inputs:** Both systems share `nixpkgs` versions via `flake.lock`.
*   **NixOS (`z2-mini`):** Implements Home Manager as a system module for atomic updates.
*   **macOS (`mbp-14`):** Uses Home Manager in standalone mode.

### Shared Configuration (`modules/home/`)

*   **`modules/home/core.nix`**: Contains the bulk of user configuration (Packages, Shells, Git, etc.).
*   **Host Specifics**: `home.username` and `home.homeDirectory` are defined in `hosts/<machine>/home.nix` to allow portability.

## 4. Workflow

### Updating the MacBook (`mbp-14`)
```bash
nix run home-manager/master -- switch --flake .#wjkoh@mbp-14
```
*Note: The flake output for Home Manager usually follows `username@hostname` or just `username` depending on configuration. We will target `wjkoh` explicitly.*

### Updating the HP Z2 (`z2-mini`)
```bash
nixos-rebuild switch --flake .#z2-mini
```

## 5. Benefits
1.  **Single Source of Truth:** Change configuration once, propagate to all machines.
2.  **Shared Lockfile:** Ensures identical tool versions across macOS and Linux.
3.  **Atomic Updates:** On NixOS, system and user configs update synchronously.
