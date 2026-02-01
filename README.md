# Unified Nix Config for NixOS and macOS

## 1. Overview
The goal of this repository is to manage distinct systems using a single Git repository and Flake:
1.  **MacBook Pro 14 (macOS):** Hostname `mbp-14`. Uses Home Manager (standalone) to manage user tools and dotfiles.
    > **Setup:** To set the hostname on macOS, run:
    > ```bash
    > sudo scutil --set ComputerName "mbp-14"
    > sudo scutil --set LocalHostName "mbp-14"
    > sudo scutil --set HostName "mbp-14"
    > ```
2.  **HP Z2 Mini G1a (NixOS):** Hostname `z2-mini`. Uses NixOS for system configuration and Home Manager (as a module) for user configuration.

**Key Philosophy:** "Write once, run everywhere" for user tools (Neovim, Zsh, Git, etc.), while keeping system-specific configurations (disk mounts, networking, macOS settings) separate.

## 2. Directory Structure

This repository uses a modular structure to maximize code reuse:

```text
.
├── .envrc                   # Direnv configuration (auto-loads dev shell)
├── .pre-commit-config.yaml  # Code formatting and linting rules
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
│       ├── hardware-configuration.nix
│       └── home.nix         # NixOS-specific home overrides
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

## 4. Security & Authentication

*   **[YubiKey SSH Guide](yubikey.md)**: Instructions for setting up FIDO2-based SSH authentication for passwordless, secure access to remote machines.

## 5. Workflow

### Updating mbp-14 (MacBook Pro)
You can run Home Manager using `nix run` without installing the `home-manager` CLI tool globally.

```bash
# From local source
$ nix run home-manager/master -- switch --flake .#wjkoh@mbp-14

# Directly from GitHub (useful for bootstrapping)
$ nix run home-manager/master -- switch --flake github:wjkoh/nix-config#wjkoh@mbp-14
```

### Updating z2-mini (HP Z2 Mini)
```bash
# From local source
# nixos-rebuild switch --flake .#z2-mini

# Directly from GitHub
# nixos-rebuild switch --flake github:wjkoh/nix-config#z2-mini
```

## 6. Benefits
1.  **Single Source of Truth:** Change configuration once, propagate to all machines.
2.  **Shared Lockfile:** Ensures identical tool versions across macOS and Linux.
3.  **Atomic Updates:** On NixOS, system and user configs update synchronously.

## 7. Post-Installation Steps

After applying the configuration, some manual steps are required:

### Tailscale
*   **macOS (`mbp-14`):** Install Tailscale manually via the Mac App Store or as a standalone app.
*   **NixOS (`z2-mini`):** Tailscale is managed as a system service. Run `sudo tailscale up` to authenticate.

### Google Cloud SDK
On both systems, you must authenticate manually to use `gcloud` and application default credentials:
```bash
$ gcloud auth login
$ gcloud auth application-default login
```
