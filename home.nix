{
  config,
  pkgs,
  neovim,
  ...
}: {
  home.username = "wjkoh";
  home.homeDirectory = "/Users/wjkoh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = [
    neovim.packages.${pkgs.system}.default
    pkgs.bat
    pkgs.git
    pkgs.lazygit
    pkgs.fx
    pkgs.gh
    pkgs.curl
    pkgs.tldr
    pkgs.lazydocker
    pkgs.btop
    pkgs.nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
    MANPAGER = "nvim +Man!";
    LANG = "en_US.UTF-8";
  };

  xdg.configFile."ghostty/config".text = ''
    theme = Catppuccin Mocha
    font-family = JetBrainsMono Nerd Font Mono
    font-size = 14
    window-padding-x = 10
    window-padding-y = 10
    macos-titlebar-style = transparent
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      cat = "bat";
      g = "git";
      lg = "lazygit";
      ld = "lazydocker";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.delta = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Woojong Koh";
        email = "wjngkoh@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
