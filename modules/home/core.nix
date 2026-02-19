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
    pkgs.lazyjj
    pkgs.lazyjournal
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
  ];

  programs.lazydocker.enable = true;
  programs.lazysql.enable = true;

  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "rg40xxv" = {
          id = "XRSMHL3-TW4FT7D-HRMN72W-PQUCTH7-TCHA4IZ-YB756RB-D7HECDX-A5DKHAV";
        };
        "mbp-14" = {
          id = "ZUSXIMP-72YTSXV-SIDIKNA-P7RAW55-QKROULC-7LQWC5B-SSPVNAP-A4CQFAZ";
        };
      };
      folders = {
        "muos-save" = {
          id = "5uzle-nvuvj";
          path = "~/muos/save";
          devices = ["rg40xxv" "mbp-14"];
          versioning = {
            type = "simple";
            params = {
              keep = "5";
            };
          };
        };
        "muos-roms" = {
          id = "qheiz-cageo";
          path = "~/muos/roms";
          devices = ["rg40xxv" "mbp-14"];
          versioning = {
            type = "simple";
            params = {
              keep = "5";
            };
          };
        };
        "muos-bios" = {
          id = "wnx3q-dqhbd";
          path = "~/muos/bios";
          devices = ["rg40xxv" "mbp-14"];
          versioning = {
            type = "simple";
            params = {
              keep = "5";
            };
          };
        };
      };
    };
  };

  home.file."muos/save/.stignore".text = ''
    .DS_Store
  '';
  home.file."muos/roms/.stignore".text = ''
    .DS_Store
  '';
  home.file."muos/bios/.stignore".text = ''
    .DS_Store
  '';

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
      },
      "model": {
        "name": "gemini-3-pro-preview"
      }
    }
  '';

  home.file."GEMINI.md".text = builtins.readFile ./GEMINI_root.md;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      setopt HUP
    '';
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

  home.file."${
    if pkgs.stdenv.isDarwin
    then "Library/Preferences"
    else ".config"
  }/glow/glow.yml".text = ''
    tui: true
  '';

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$env_var$all";
      env_var = {
        SHPOOL_SESSION_NAME = {
          format = "[[$env_value]](bold green) ";
          variable = "SHPOOL_SESSION_NAME";
        };
      };
    };
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
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      navigate = true;
      keep-plus-minus-markers = true;
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
    };
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      git = {
        pagers = [{pager = "delta --paging=never";}];
      };
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Woojong Koh";
        email = "wjngkoh@gmail.com";
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
