{pkgs, ...}: {
  services.aerospace = {
    enable = true;
    settings = let
      appRules = [
        # --- Terminal (T) ---
        {
          id = "com.mitchellh.ghostty";
          workspace = "T";
        }

        # --- Code (C) ---
        {
          id = "com.apple.dt.Xcode";
          workspace = "C";
        }
        {
          id = "com.postmanlabs.mac";
          workspace = "C";
        }
        {
          id = "com.google.Chrome.app.mjoklplbddabcmpepnokjaffbmgbkkgg";
          workspace = "C";
        } # GitHub PWA
        {
          id = "com.google.Chrome.app.ahiigpfcghkbjfcibpojancebdfjmoop";
          workspace = "C";
        } # DevDocs PWA
        {
          id = "com.google.Chrome";
          title = "GitHub";
          workspace = "C";
        } # GitHub Tab

        # --- Notes & Writing (N) ---
        {
          id = "pro.writer.mac";
          workspace = "N";
        } # iA Writer
        {
          id = "com.apple.Notes";
          workspace = "N";
        } # Apple Notes
        {
          id = "com.apple.journal";
          workspace = "N";
        } # Apple Journal

        # --- Plan & People (P) ---
        {
          id = "com.apple.reminders";
          workspace = "P";
        } # Reminders
        {
          id = "com.apple.iCal";
          workspace = "P";
        } # Apple Calendar
        {
          id = "app.folk.app";
          workspace = "P";
        } # Folk
        {
          id = "net.cementpla.FocusFlights";
          workspace = "P";
        } # FocusFlight

        # --- Reading (R) ---
        {
          id = "com.ranchero.NetNewsWire-Evergreen";
          workspace = "R";
        } # NetNewsWire
        {
          id = "com.ngocluu.goodlinks";
          workspace = "R";
        } # GoodLinks
        {
          id = "com.amazon.Lassen";
          workspace = "R";
        } # Kindle
        {
          id = "com.outreadapp.Outread";
          workspace = "R";
        } # Outread
        {
          id = "com.apple.news";
          workspace = "R";
        } # Apple News
        {
          id = "com.apple.iBooksX";
          workspace = "R";
        } # Apple Books
        {
          id = "com.apple.Preview";
          workspace = "R";
        } # Apple Preview
        {
          id = "com.google.Chrome.app.lgnggepjiihbfdbedefdhcffnmhcahbm";
          workspace = "R";
        } # Reddit PWA
        {
          id = "com.google.Chrome.app.lodlkdfmihgonocnmddehnfgiljnadcf";
          workspace = "R";
        } # X PWA
        {
          id = "com.google.Chrome.app.efcincablbegedjcjafhdbjgdohhgfpp";
          workspace = "R";
        } # RIDI PWA
        {
          id = "com.initialcoms.BOM";
          workspace = "R";
        } # RIDI Native
        {
          id = "com.google.Chrome.app.akpamiohjfcnimfljfndmaldlcfphjmp";
          workspace = "R";
        } # Instagram PWA

        # --- Messaging (M) ---
        {
          id = "com.apple.mail";
          workspace = "M";
        } # Apple Mail
        {
          id = "com.kakao.KakaoTalkMac";
          workspace = "M";
        } # KakaoTalk
        {
          id = "com.hnc.Discord";
          workspace = "M";
        } # Discord
        {
          id = "com.tinyspeck.slackmacgap";
          workspace = "M";
        } # Slack
        {
          id = "ru.keepcoder.Telegram";
          workspace = "M";
        } # Telegram
        {
          id = "us.zoom.xos";
          workspace = "M";
        } # Zoom
        {
          id = "com.google.Chrome.app.pommaclcbfghclhalboakcipcmmndhcj";
          workspace = "M";
        } # Google Chat
        {
          id = "com.google.Chrome";
          title = "Google Chat";
          workspace = "M";
        } # Google Chat Tab

        # --- Security (S) ---
        {
          id = "com.bitwarden.desktop";
          workspace = "S";
        }
        {
          id = "com.yubico.yubioath";
          workspace = "S";
        }
        {
          id = "com.daisydiskapp.DaisyDiskStandAlone";
          workspace = "S";
        }

        # --- Finance (F) ---
        {
          id = "com.ledger.live";
          workspace = "F";
        }
        {
          id = "io.trezor.suite";
          workspace = "F";
        }
        {
          id = "com.apple.stocks";
          workspace = "F";
        }

        # --- Games (G) ---
        {
          id = "com.valvesoftware.steam";
          workspace = "G";
        }

        # --- Lifestyle (O) ---
        {
          id = "com.apple.Maps";
          workspace = "O";
        }
        {
          id = "com.apple.weather";
          workspace = "O";
        }
        {
          id = "com.apple.Photos";
          workspace = "O";
        }
        {
          id = "com.apple.ScreenContinuity";
          workspace = "O";
        } # iPhone Mirroring

        # --- Entertainment (E) ---
        {
          id = "com.apple.Music";
          workspace = "E";
        } # Music
        {
          id = "com.apple.podcasts";
          workspace = "E";
        } # Podcasts
        {
          id = "com.google.Chrome.app.cinhimbnkkaeohfgghhklpknlkffjgod";
          workspace = "E";
        } # YouTube Music PWA
        {
          id = "com.apple.TV";
          workspace = "E";
        } # TV
        {
          id = "com.google.Chrome.app.agimnkijcaahngcdmfeangaknmldooml";
          workspace = "E";
        } # YouTube PWA
        {
          id = "com.google.Chrome";
          title = "YouTube";
          workspace = "E";
        }

        # --- Utilities (Floating) ---
        {
          id = "com.apple.finder";
          floating = true;
        }
        {
          id = "org.pqrs.Karabiner-Elements.Settings";
          floating = true;
        }
        {
          id = "com.bitwarden.desktop";
          workspace = "S";
          floating = true;
        }
        {
          id = "com.apple.Passwords";
          floating = true;
        }
        {
          id = "com.apple.AppStore";
          floating = true;
        }

        # --- Browser (Catch-All) ---
        {
          id = "com.apple.Safari";
          workspace = "B";
        }
        {
          id = "com.google.Chrome";
          workspace = "B";
        }
      ];

      mkRule = rule: {
        "if" =
          {
            app-id = rule.id;
          }
          // (
            if rule ? title
            then {window-title-regex-substring = rule.title;}
            else {}
          );
        run =
          (
            if rule ? floating && rule.floating
            then ["layout floating"]
            else []
          )
          ++ (
            if rule ? workspace
            then ["move-node-to-workspace ${rule.workspace}"]
            else []
          );
      };
    in {
      # Place a copy of this config to ~/.aerospace.toml
      # After that, you can edit ~/.aerospace.toml to your liking

      # Config version for compatibility and deprecations
      # Fallback value (if you omit the key): config-version = 1
      config-version = 2;

      # You can use it to add commands that run after AeroSpace startup.
      # Available commands : https://nikitabobko.github.io/AeroSpace/commands
      after-startup-command = [
        "exec-and-forget open -a 'Google Chrome'"
        "exec-and-forget open -a Ghostty"
        "exec-and-forget open -a KakaoTalk"
        "exec-and-forget open -a 'Google Chat'"
        "exec-and-forget open -a folk"
        "exec-and-forget open -a 'iA Writer'"
      ];

      # Start AeroSpace at login
      start-at-login = false;

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      # The 'accordion-padding' specifies the size of accordion padding
      # You can set 0 to disable the padding feature
      accordion-padding = 30;

      # Possible values: tiles|accordion
      default-root-container-layout = "tiles";

      # Possible values: horizontal|vertical|auto
      # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
      #               tall monitor (anything higher than wide) gets vertical orientation
      default-root-container-orientation = "auto";

      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      # Fallback value (if you omit the key): on-focused-monitor-changed = []
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];

      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
      # Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
      automatically-unhide-macos-hidden-apps = false;

      on-window-detected = map mkRule appRules;

      # List of workspaces that should stay alive even when they contain no windows,
      # even when they are invisible.
      # This config version is only available since 'config-version = 2'
      # Fallback value (if you omit the key): persistent-workspaces = []
      persistent-workspaces = [
        "B"
        "C"
        "E"
        "F"
        "G"
        "M"
        "N"
        "O"
        "P"
        "R"
        "S"
        "T"
      ];

      # A callback that runs every time binding mode changes
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # See: https://nikitabobko.github.io/AeroSpace/commands#mode
      on-mode-changed = [];

      # Possible values: (qwerty|dvorak|colemak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      key-mapping.preset = "qwerty";

      # Gaps between windows (inner-*) and between monitor edges (outer-*).
      # Possible values:
      # - Constant:     gaps.outer.top = 8
      # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
      #                 In this example, 24 is a default value when there is no match.
      #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
      #                 See:
      #                 https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
      gaps = {
        inner.horizontal = 5;
        inner.vertical = 5;
        outer.left = 5;
        outer.bottom = 5;
        outer.top = 5;
        outer.right = 5;
      };

      # 'main' binding mode declaration
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # 'main' binding mode must be always presented
      # Fallback value (if you omit the key): mode.main.binding = {}
      mode.main.binding = {
        # All possible keys:
        # - Letters.        a, b, c, ..., z
        # - Numbers.        0, 1, 2, ..., 9
        # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
        # - F-keys.         f1, f2, ..., f20
        # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon,
        #                   backtick, leftSquareBracket, rightSquareBracket, space, enter, esc,
        #                   backspace, tab, pageUp, pageDown, home, end, forwardDelete,
        #                   sectionSign (ISO keyboards only, european keyboards only)
        # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
        #                   keypadMinus, keypadMultiply, keypadPlus
        # - Arrows.         left, down, up, right

        # All possible modifiers: cmd, alt, ctrl, shift

        # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

        # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
        # You can uncomment the following lines to open up terminal with alt + enter shortcut
        # (like in i3)
        # alt-enter = '''exec-and-forget osascript -e '
        # tell application "Terminal"
        #     do script
        #     activate
        # end tell'
        # '''

        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        alt-b = "workspace B";
        alt-c = "workspace C";
        alt-e = "workspace E";
        alt-f = "workspace F";
        alt-g = "workspace G";
        alt-m = "workspace M";
        alt-n = "workspace N";
        alt-o = "workspace O";
        alt-p = "workspace P";
        alt-r = "workspace R";
        alt-s = "workspace S";
        alt-t = "workspace T";

        alt-rightSquareBracket = "workspace next";
        alt-leftSquareBracket = "workspace prev";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        alt-shift-b = "move-node-to-workspace B";
        alt-shift-c = "move-node-to-workspace C";
        alt-shift-e = "move-node-to-workspace E";
        alt-shift-f = "move-node-to-workspace F";
        alt-shift-g = "move-node-to-workspace G";
        alt-shift-m = "move-node-to-workspace M";
        alt-shift-n = "move-node-to-workspace N";
        alt-shift-o = "move-node-to-workspace O";
        alt-shift-p = "move-node-to-workspace P";
        alt-shift-r = "move-node-to-workspace R";
        alt-shift-s = "move-node-to-workspace S";
        alt-shift-t = "move-node-to-workspace T";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-shift-semicolon = "mode service";
      };

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"]; # reset layout
        f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout
        backspace = ["close-all-windows-but-current" "mode main"];

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        #s = ['layout sticky tiling', 'mode main']

        alt-shift-h = ["join-with left" "mode main"];
        alt-shift-j = ["join-with down" "mode main"];
        alt-shift-k = ["join-with up" "mode main"];
        alt-shift-l = ["join-with right" "mode main"];
      };
    };
  };
}
