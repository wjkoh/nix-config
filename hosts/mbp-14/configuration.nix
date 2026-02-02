{pkgs, ...}: {
  # Nix configuration ------------------------------------------------------------------------------
  nix.enable = false;
  # nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # System preferences
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      persistent-apps = [
        "/Applications/Ghostty.app"
        "/Applications/Google Chrome.app"
        "/Applications/Xcode.app"
        "/Applications/Slack.app"
        "/Applications/Discord.app"
        "/Applications/Telegram.app"
        "/Applications/KakaoTalk.app"
        "/Applications/NetNewsWire.app"
        "/Applications/iA Writer.app"
        "/System/Applications/System Settings.app"
      ];
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      FXDefaultSearchScope = "SCcf";
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };
    loginwindow.LoginwindowText = "If you found this computer, please contact wjngkoh@gmail.com. Reward available.";
    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
      AppleKeyboardUIMode = 3;
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
      "com.apple.trackpad.enableSecondaryClick" = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  # Backward compatibility
  system.stateVersion = 6;

  # User setup
  users.users.wjkoh = {
    name = "wjkoh";
    home = "/Users/wjkoh";
  };

  # Set the primary user for user-dependent defaults
  system.primaryUser = "wjkoh";

  # Hostname
  networking.hostName = "mbp-14";
  networking.computerName = "mbp-14";
  networking.localHostName = "mbp-14";

  environment.systemPackages = [
    pkgs.coreutils
    pkgs.findutils
    pkgs.gnugrep
    pkgs.gnused
    pkgs.moreutils
    pkgs.watch
  ];

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    casks = [
      "discord"
      "ghostty"
      "google-chrome"
      "ledger-wallet"
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
      "Slack" = 803453959;
      "Telegram" = 747648890;
      "Yubico Authenticator" = 1497506650;
      "FocusFlight" = 6648771147;
      "DaisyDisk" = 411643860;
      "Outread" = 778846279;
    };
  };
}
