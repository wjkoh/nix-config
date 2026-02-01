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
ssh-keygen -t ed25519-sk -O resident -O application=ssh:wjkoh -N "" -f ~/.ssh/id_yubikey_1
```

Run the following for your **Backup** YubiKey:
(Plug in Backup YubiKey)
```bash
ssh-keygen -t ed25519-sk -O resident -O application=ssh:wjkoh -N "" -f ~/.ssh/id_yubikey_2
```

*   `-t ed25519-sk`: Use the FIDO2 algorithm.
*   `-O resident`: Store the key on the YubiKey (allows recovery).
*   `-N ""`: Set an empty passphrase (no password for the key file).
*   (Optional) `-O verify-required`: Add this flag if you want to require a PIN/Biometrics (User Verification). Without it, only User Presence (Touch) is required.

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
      # Bypass SSH agent to avoid "agent refused operation"
      extraOptions = {
        IdentityAgent = "none";
      };
    };
  };
};
```

## 5. Recovery (After Formatting)

If you format your MacBook, install Nix and Home Manager, then plug in a YubiKey and run:

```bash
# Downloads key stub for the plugged-in YubiKey to ~/.ssh/id_yubikey_1
task yubikey-recover NAME=id_yubikey_1
```

Repeat for your backup keys with different names.

## 6. Taskfile Commands

*   `task ssh`: SSH into z2-mini.
*   `task yubikey-generate NAME=id_yubikey_1`: Generate a new key.
*   `task yubikey-recover NAME=id_yubikey_1`: Recover a key from the physical YubiKey.

## 7. Troubleshooting & Known Issues

### 7.1. "agent refused operation" Error

**Symptoms:**
When trying to SSH, you get:
```
sign_and_send_pubkey: signing failed for ED25519-SK "/Users/.../id_yubikey_..." from agent: agent refused operation
```

**Cause:**
The macOS `ssh-agent` or other running agents often fail to handle FIDO/U2F keys correctly or get into a stale state, especially after the YubiKey is re-plugged.

**Fix:**
Bypass the SSH agent for the specific host by setting `IdentityAgent none` in `~/.ssh/config` (or your Nix configuration).
```nix
extraOptions = {
  IdentityAgent = "none";
};
```

### 7.2. Mosh: "Confirm user presence" Prompt Missing

**Symptoms:**
When connecting via `mosh`, the process hangs at the authentication step. No message appears asking you to touch the YubiKey.

**Cause:**
Mosh buffers the output differently than SSH, and the "Touch YubiKey" prompt (printed by the underlying `ssh` process) is often hidden or suppressed.

**Workaround:**
*   **Just Touch It:** If Mosh hangs during connection, touch your YubiKey. It is waiting for input even if it doesn't say so.
*   **Use SSH First:** Connect once with `ssh` to ensure keys are working, then use `mosh`.

## 8. Security Note: What to Commit?

*   **Public Keys (`.pub` files):** ✅ **SAFE**.
    *   You **SHOULD** commit these to your repo (e.g., in `configuration.nix`). They act like a lock; showing the lock is safe.
    *   Example: `sk-ssh-ed25519@openssh.com AAAAGn...`

*   **Private Key Stubs (files with no extension):** ❌ **PRIVATE**.
    *   **DO NOT** commit these (`~/.ssh/id_yubikey_1`).
    *   Even though they don't contain the actual secret (which is on the hardware YubiKey), they are useless to others and should be treated as private credentials.
    *   Ensure your `.gitignore` excludes them (usually standard practice).

## 9. Sudo with YubiKey (NixOS)

You can use your YubiKey to authorize `sudo` commands on `z2-mini` instead of typing your password. We use `pam_u2f` for this.

### 9.1. Generate Configuration (On macOS)

Since `z2-mini` is remote, you can generate the configuration on your Mac. You must specify the **origin** (`pam://hostname`) so the YubiKey knows which machine asks for the credential.

1.  Plug in your YubiKey.
2.  Run the following (replace `z2-mini` with your actual hostname if different):

    ```bash
    nix shell nixpkgs#pam_u2f -c "pamu2fcfg -o pam://z2-mini"
    ```

3.  Touch your YubiKey when it blinks.
4.  Copy the output (starts with `username:...`).

### 9.2. Apply to NixOS

In `hosts/z2-mini/configuration.nix`, enable `pam.u2f` and add the config:

```nix
security.pam.u2f = {
  enable = true;
  settings = {
    # Set to true to effectively disable password login if YubiKey is present.
    # We recommend false initially to allow fallback to password.
    cue = true;  # Tell user to touch the device
    origin = "pam://z2-mini";
  };
  # Map username to the key string you generated
  authFile = pkgs.writeText "u2f-mappings" ''
    wjkoh:long-string-from-step-9.1...
  '';
};
```
