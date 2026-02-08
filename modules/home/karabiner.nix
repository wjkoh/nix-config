{pkgs, ...}: {
  xdg.configFile."karabiner/karabiner.json" = {
    force = true;
    text = builtins.toJSON {
      profiles = [
        {
          name = "Default";
          show_in_menu_bar = false;
          complex_modifications = {
            rules = [
              {
                description = "Caps Lock to Ctrl (Hold) / Esc (Tap)";
                manipulators = [
                  {
                    from = {
                      key_code = "caps_lock";
                      modifiers = {optional = ["any"];};
                    };
                    to = [{key_code = "left_control";}];
                    to_if_alone = [
                      {key_code = "escape";}
                      {select_input_source = {language = "^en$";};}
                    ];
                    type = "basic";
                  }
                ];
              }
              {
                description = "Esc switches to English";
                manipulators = [
                  {
                    from = {key_code = "escape";};
                    to = [
                      {key_code = "escape";}
                      {select_input_source = {language = "^en$";};}
                    ];
                    type = "basic";
                  }
                ];
              }
            ];
          };
          devices = [
            {
              identifiers = {
                is_keyboard = true;
                is_pointing_device = true;
                product_id = 10203;
                vendor_id = 5824;
              };
              ignore = false;
            }
          ];
          virtual_hid_keyboard = {keyboard_type_v2 = "ansi";};
        }
      ];
    };
  };
}
