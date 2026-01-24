{ pkgs, ... }: {
  imports = [ ../../modules/home/default.nix ];

  home.username = "wjkoh";
  home.homeDirectory = "/Users/wjkoh";
}
