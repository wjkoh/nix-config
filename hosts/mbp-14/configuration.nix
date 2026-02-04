{pkgs, ...}: {
  imports = [
    ./aerospace.nix
  ];

  # Nix configuration ------------------------------------------------------------------------------
  nix.enable = false;
  # nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # Nix Store Maintenance
  # Disabled because they require nix.enable = true, which conflicts with Determinate Nix
  # nix.optimise.automatic = true;
  # nix.gc.automatic = true;

  # Window Management
  services.jankyborders = {
    enable = true;
    width = 5.0;
    active_color = "0xffe1e3e4";
    inactive_color = "0xff494d64";
  };

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # System preferences
  system.defaults = {
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
    };
    dock = {
      scroll-to-open = true;
      autohide = true;
      expose-group-apps = true;
      show-recents = false;
      mru-spaces = false;
      orientation = "bottom";
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
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 13;
      wvous-br-corner = 2;
    };
    finder = {
      QuitMenuItem = true;
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      FXDefaultSearchScope = "SCcf";
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      FXRemoveOldTrashItems = true;
    };
    loginwindow = {
      GuestEnabled = false;
      LoginwindowText = "Found this? Contact wjngkoh@gmail.com. Cash reward.";
    };
    spaces.spans-displays = true;
    NSGlobalDomain = {
      AppleSpacesSwitchOnActivate = false;
      NSWindowShouldDragOnGesture = true;
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
      TrackpadThreeFingerDrag = false;
    };
    WindowManager.GloballyEnabled = false;
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
  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
    allowSigned = true;
    allowSignedApp = true;
  };

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
