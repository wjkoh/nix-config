{
  pkgs,
  neovim,
  ...
}: {
  home.packages = [
    neovim.packages.${pkgs.system}.default
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
  };
}
