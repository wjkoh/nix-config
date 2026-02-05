{pkgs, ...}: {
  xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON {
    profiles = [
      {
        name = "Default";
        complex_modifications = {
          rules = [
            {
              description = "Tab to Alt (Hold) / Tab (Tap)";
              manipulators = [
                {
                  from = {key_code = "tab";};
                  to = [{key_code = "tab";}];
                  to_if_held_down = [{key_code = "left_option";}];
                  type = "basic";
                }
              ];
            }
            {
              description = "Caps Lock to Ctrl (Hold) / Esc (Tap)";
              manipulators = [
                {
                  from = {
                    key_code = "caps_lock";
                    modifiers = {optional = ["any"];};
                  };
                  to = [{key_code = "left_control";}];
                  to_if_alone = [{key_code = "escape";}];
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
      }
    ];
  };
}
