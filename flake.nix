{
  description = "Unified NixOS and Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:wjkoh/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    neovim,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#z2-mini'
    nixosConfigurations = {
      "z2-mini" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          # Main NixOS configuration file
          ./hosts/z2-mini/configuration.nix
          
          # Home Manager module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs outputs neovim;};
            home-manager.users.wjkoh = import ./hosts/z2-mini/home.nix;
          }
        ];
      };
    };

    # Standalone Home Manager configuration entrypoint
    # Available through 'home-manager --flake .#wjkoh@mbp-14'
    homeConfigurations = {
      "wjkoh@mbp-14" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs neovim;};
        modules = [
          ./hosts/mbp-14/home.nix
        ];
      };
    };
  };
}