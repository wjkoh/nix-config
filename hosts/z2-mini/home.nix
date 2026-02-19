{pkgs, ...}: {
  imports = [../../modules/home/default.nix];

  home.username = "wjkoh";
  home.homeDirectory = "/home/wjkoh";

  services.shpool = {
    enable = true;
    settings = {
      session_restore_mode = "simple";
      prompt_prefix = "";
    };
  };

  programs.zsh.initContent = ''
    # Show shpool info on SSH login
    if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$SHPOOL_SESSION_NAME" ]]; then
        if command -v shpool >/dev/null 2>&1; then
            echo "--- shpool sessions ---"
            shpool list
            echo ""
            echo "Commands:"
            echo "  Attach: shpool attach <name>"
            echo "  List:   shpool list"
            echo "  Detach: (Ctrl-Space, Ctrl-q) or shpool detach <name>"
            echo "  Kill:   shpool kill <name>"
            echo "-----------------------"
        fi
    fi
  '';
}
