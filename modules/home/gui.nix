{pkgs, ...}: {
  xdg.configFile."ghostty/config".text = ''
    theme = Catppuccin Mocha
    font-family = JetBrainsMono Nerd Font Mono
    font-size = 14
    window-padding-x = 10
    window-padding-y = 10
    macos-titlebar-style = transparent
  '';

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
                      optional = ["any"];
                    };
                  };
                  to = [
                    {key_code = "escape";}
                    {select_input_source = {language = "^en$";};}
                  ];
                }
              ];
            }
          ];
        };
        devices = [];
        fn_function_keys = [];
        simple_modifications = [];
        virtual_hid_keyboard = {
          keyboard_type_v2 = "ansi";
        };
      }
    ];
  };
}
