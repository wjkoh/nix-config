{pkgs, ...}: {
  xdg.configFile."karabiner/karabiner.json" = {
    force = true;
    text = builtins.toJSON {
      profiles = [
        {
          name = "Default";
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
                vendor_id = 5824;
                is_keyboard = true;
                is_pointing_device = false;
              };
              ignore = false;
            }
          ];
        }
      ];
    };
  };
}
