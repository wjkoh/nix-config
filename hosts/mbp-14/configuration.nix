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
      "google-chrome"
      "netnewswire"
      "postman"
      "steam"
      "trezor-suite"
      "zoom"
    ];
    masApps = {
      "Bitwarden" = 1352778147;
      "Tailscale" = 1475387142;
      "GoodLinks" = 1474335294;
      "iA Writer" = 775737590;
      "KakaoTalk" = 869223134;
      "Amazon Kindle" = 302584613;
      "Xcode" = 497799835;
      "Ridi" = 338813698;
      "Slack" = 803453959;
      "Telegram" = 747648890;
      "Yubico Authenticator" = 1497506650;
    };
  };
}
