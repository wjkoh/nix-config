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
    llama-cpp.url = "github:ggerganov/llama.cpp";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    neovim,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.alejandra
          pkgs.pre-commit
          pkgs.go-task
        ];
        shellHook = ''
          pre-commit install
        '';
      };
    });

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#z2-mini'
    nixosConfigurations = {
      "z2-mini" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          # Main NixOS configuration file
          ./hosts/z2-mini/configuration.nix

          # Enable unfree packages
          {nixpkgs.config.allowUnfree = true;}

          # Home Manager module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs outputs neovim;
              llamaCppPackage = inputs.llama-cpp.packages.x86_64-linux.vulkan;
            };
            home-manager.users.wjkoh = import ./hosts/z2-mini/home.nix;
          }
        ];
      };
    };

    # Standalone Home Manager configuration entrypoint
    # Available through 'home-manager --flake .#wjkoh@mbp-14'
    homeConfigurations = {
      "wjkoh@mbp-14" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs outputs neovim;
          llamaCppPackage = inputs.llama-cpp.packages.aarch64-darwin.default;
        };
        modules = [
          ./hosts/mbp-14/home.nix
        ];
      };
    };
  };
}
