{
  pkgs,
  llamaCppPackage,
  ...
}: {
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = [
    llamaCppPackage
    pkgs.btop
    pkgs.curl
    pkgs.duf
    pkgs.fd
    pkgs.fx
    pkgs.gdu
    pkgs.gemini-cli
    pkgs.git
    pkgs.glow
    pkgs.go-task
    pkgs.google-cloud-sdk
    pkgs.gron
    pkgs.grpcurl
    pkgs.jq
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.lazyjj
    pkgs.lazyjournal
    pkgs.lazysql
    pkgs.less
    pkgs.libfido2
    pkgs.marp-cli
    pkgs.mosh
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nethack
    pkgs.openssh
    pkgs.ripgrep
    pkgs.sshfs
    pkgs.tldr
    pkgs.yubikey-manager
    pkgs.yq-go
    pkgs.zellij
  ];

  home.sessionVariables = {
    PAGER = "less";
    LANG = "en_US.UTF-8";
    GOOGLE_CLOUD_PROJECT = "docugpt-test";
    GOOGLE_CLOUD_LOCATION = "global";
  };

  home.file.".gemini/settings.json".text = ''
    {
      "security": {
        "auth": {
          "selectedType": "vertex-ai"
        }
      },
      "general": {
        "previewFeatures": true,
        "preferredEditor": "neovim"
      }
    }
  '';

  home.file."GEMINI.md".text = builtins.readFile ./GEMINI_root.md;

  xdg.configFile."zellij/config.kdl" = {
    text = ''
      pane_frames false
      default_layout "compact"
      mouse_mode true
      theme "catppuccin-mocha"
      show_startup_tips false
      show_release_notes false
      simplified_ui true
    '';
    force = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cat = "bat";
      df = "duf";
      du = "gdu";
      man = "tldr";
      ls = "eza --icons";
      ll = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      lx = "eza -lbhHigUmuSa --time-style=long-iso --git --color-scale";

      # Git
      g = "git";
      lg = "lazygit";
      gs = "git status";
      ga = "git add";
      gcm = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gf = "git fetch";
      gup = "git fetch && git rebase";
      gp = "git push";
      glog = "git log --oneline --graph --decorate";

      # Docker
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
    options = ["--cmd cd"];
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

  programs.delta = {
    enable = true;
    enableJujutsuIntegration = true;
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

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Woojong Koh";
        email = "wjngkoh@gmail.com";
      };
      ui = {
        paginate = "never";
      };
      merge-tools.vimdiff = {
        program = "nvim";
      };
      lazyjj = {
        diff-tool = "delta";
      };
    };
  };

  programs.jjui = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
