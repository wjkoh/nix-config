# YubiKey SSH Setup (The Nix Way)

This guide explains how to configure YubiKey-based SSH authentication between a MacBook Pro (macOS + Nix) and a remote NixOS machine (`z2-mini`). We use **FIDO2 Resident Keys** (ed25519-sk) for a modern, secure, and recoverable setup. This setup supports **multiple YubiKeys** (e.g., primary and backup).

## 1. Prerequisites

*   One or more YubiKey 5 series or newer (supports FIDO2/U2F).
*   OpenSSH 8.2+ (standard on recent macOS and NixOS).
*   `z2-mini` accessible via network (e.g., Tailscale).

## 2. Setup (On MacBook Pro)

We will generate "resident keys". This stores the key handle and metadata directly on each YubiKey.

### Step 2.1: Generate Keys

Run the following for your **Primary** YubiKey:
(Plug in Primary YubiKey)
```bash
ssh-keygen -t ed25519-sk -O resident -O application=ssh:wjkoh -O verify-required -f ~/.ssh/id_yubikey_1
```

Run the following for your **Backup** YubiKey:
(Plug in Backup YubiKey)
```bash
ssh-keygen -t ed25519-sk -O resident -O application=ssh:wjkoh -O verify-required -f ~/.ssh/id_yubikey_2
```

*   `-t ed25519-sk`: Use the FIDO2 algorithm.
*   `-O resident`: Store the key on the YubiKey (allows recovery).
*   `-O verify-required`: Require a PIN or biometric verification.

### Step 2.2: Get Public Keys

Display the public keys to add to NixOS:

```bash
cat ~/.ssh/id_yubikey_*.pub
```

You will see output for both keys.

## 3. NixOS Configuration (`z2-mini`)

On the remote machine (or in your `nix-config` repo), update `hosts/z2-mini/configuration.nix`.

Add **BOTH** public keys to the user's authorized keys:

```nix
users.users.wjkoh.openssh.authorizedKeys.keys = [
  "sk-ssh-ed25519@openssh.com AAAAGn... (content of id_yubikey_1.pub)"
  "sk-ssh-ed25519@openssh.com AAAAGn... (content of id_yubikey_2.pub)"
];
```

Deploy the change to `z2-mini`.

## 4. Home Manager Configuration (`mbp-14`)

Ensure your SSH client is configured to try both keys. In `modules/home/core.nix`:

```nix
programs.ssh = {
  enable = true;
  addKeysToAgent = "yes";
  matchBlocks = {
    "z2-mini" = {
      hostname = "z2-mini";
      user = "wjkoh";
      # SSH will try these keys in order
      identityFile = [
        "~/.ssh/id_yubikey_1"
        "~/.ssh/id_yubikey_2"
      ];
    };
  };
};
```

## 5. Recovery (After Formatting)

If you format your MacBook, install Nix and Home Manager, then plug in a YubiKey and run:

```bash
# Downloads key stub for the plugged-in YubiKey
ssh-keygen -K
```

Rename the resulting `id_ed25519_sk` file to match your naming convention (e.g., `id_yubikey_1` or `id_yubikey_2`).

## 6. Taskfile Commands

*   `task ssh`: SSH into z2-mini.
*   `task yubikey-generate NAME=id_yubikey_3`: Generate a new key with a specific name.
