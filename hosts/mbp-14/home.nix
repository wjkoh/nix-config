{pkgs, ...}: {
  imports = [../../modules/home/default.nix];

  home.username = "wjkoh";
  home.homeDirectory = "/Users/wjkoh";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "z2-mini" = {
        hostname = "z2-mini";
        user = "wjkoh";
        identityFile = [
          "~/.ssh/id_yubikey_nano113"
          "~/.ssh/id_yubikey_nfc056"
          "~/.ssh/id_yubikey_nfc836"
        ];
        extraOptions = {
          IdentityAgent = "none";
        };
      };
    };
  };

  xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON {
    global = {
      check_for_updates_on_startup = true;
      show_in_menu_bar = true;
      show_profile_name_in_menu_bar = false;
    };
    profiles = [
      {
        name = "Default";
        complex_modifications = {
          rules = [
            {
              description = "Escape to English";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "escape";
                    modifiers = {
                      optional = [
                        "any"
                      ];
                    };
                  };
                  to = [
                    {
                      key_code = "escape";
                    }
                    {
                      select_input_source = {
                        language = "^en$";
                      };
                    }
                  ];
                }
              ];
            }
            {
              description = "Caps Lock to Control";
              manipulators = [
                {
                  from = {
                    key_code = "caps_lock";
                    modifiers = {
                      optional = [
                        "any"
                      ];
                    };
                  };
                  to = [
                    {
                      key_code = "left_control";
                    }
                  ];
                  type = "basic";
                }
              ];
            }
          ];
        };
        devices = [];
        fn_function_keys = [];
        selected = true;
        simple_modifications = [];
        virtual_hid_keyboard = {
          keyboard_type_v2 = "ansi";
        };
      }
    ];
  };
}
