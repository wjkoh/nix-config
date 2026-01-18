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
    pkgs.btop
    pkgs.curl
    pkgs.fd
    pkgs.fx
    pkgs.gemini-cli
    pkgs.git
    pkgs.go-task
    pkgs.google-cloud-sdk
    pkgs.gron
    pkgs.grpcurl
    pkgs.jq
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.less
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nethack
    pkgs.ripgrep
    pkgs.tldr
    pkgs.yq-go
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
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

  home.file.".gemini/settings.json".text = ''
    {
      "general": {
        "preferredEditor": "Neovim",
        "vimMode": true,
        "previewFeatures": true
      },
      "model": {
        "name": "gemini-3-pro-preview"
      },
      "security": {
        "auth": {
          "selectedType": "oauth-personal"
        }
      }
    }
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      lx = "eza -lbhHigUmuSa --time-style=long-iso --git --color-scale";
      g = "git";
      lg = "lazygit";
      ld = "lazydocker";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    ];
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      show_startup_tips = false;
    };
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };

  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-dash];
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Woojong Koh";
        email = "wjngkoh@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
