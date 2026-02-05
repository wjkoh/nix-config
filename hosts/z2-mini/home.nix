{pkgs, ...}: {
  imports = [../../modules/home/default.nix];

  home.username = "wjkoh";
  home.homeDirectory = "/home/wjkoh";

  programs.zsh.initContent = ''
    # Auto-start Zellij on SSH
    if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$ZELLIJ" ]]; then
        exec zellij attach --create default
    fi
  '';
}
