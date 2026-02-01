{pkgs, ...}: {
  imports = [../../modules/home/default.nix];

  home.username = "wjkoh";
  home.homeDirectory = "/Users/wjkoh";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "z2-mini" = {
        hostname = "z2-mini";
        user = "wjkoh";
        identityFile = [
          "~/.ssh/id_yubikey_nano113"
        ];
        extraOptions = {
          IdentityAgent = "none";
        };
      };
    };
  };
}
