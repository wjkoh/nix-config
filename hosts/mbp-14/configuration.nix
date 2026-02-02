{pkgs, ...}: {
  # Nix configuration ------------------------------------------------------------------------------
  nix.enable = false;
  # nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # System preferences
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
    };
  };

  # Backward compatibility
  system.stateVersion = 5;

  # User setup
  users.users.wjkoh = {
    name = "wjkoh";
    home = "/Users/wjkoh";
  };

  # Set the primary user for user-dependent defaults
  system.primaryUser = "wjkoh";

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    casks = [
      "ghostty"
    ];
    masApps = {
      "Bitwarden" = 1352778147;
      "Tailscale" = 1475387142;
    };
  };
}
