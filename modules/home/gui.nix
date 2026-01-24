{pkgs, ...}: {
  xdg.configFile."ghostty/config".text = ''
    theme = Catppuccin Mocha
    font-family = JetBrainsMono Nerd Font Mono
    font-size = 14
    window-padding-x = 10
    window-padding-y = 10
    macos-titlebar-style = transparent
  '';
}
