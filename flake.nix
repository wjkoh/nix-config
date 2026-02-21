{
  description = "Unified NixOS and Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:wjkoh/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hayes.url = "path:/home/wjkoh/hayes";
    hayes.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    neovim,
    hayes,
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
          pkgs.lefthook
          pkgs.yamllint
          pkgs.go-task
        ];
        shellHook = ''
          lefthook install
        '';
      };
    });

    checks = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      target =
        if system == "aarch64-darwin"
        then self.darwinConfigurations.mbp-14.config.system.build.toplevel
        else if system == "x86_64-linux"
        then self.nixosConfigurations.z2-mini.config.system.build.toplevel
        else null;
    in
      if target != null
      then {
        no-dotnet =
          pkgs.runCommand "check-no-dotnet" {
            nativeBuildInputs = [pkgs.gnugrep];
            exportReferencesGraph = ["graph" target];
          } ''
            if grep -q "dotnet" graph; then
              echo "Error: 'dotnet' found in the closure of ${system} configuration!"
              grep "dotnet" graph
              exit 1
            fi
            touch $out
          '';
      }
      else {});

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#z2-mini'
    nixosConfigurations = {
      "z2-mini" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          {nixpkgs.hostPlatform = "x86_64-linux";}

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
              llamaCppPackage = nixpkgs.legacyPackages.x86_64-linux.llama-cpp.override {vulkanSupport = true;};
            };
            home-manager.users.wjkoh = {
              imports = [./hosts/z2-mini/home.nix];
              manual.html.enable = false;
            };
          }

          # Import the Hayes systemd deployment module
          hayes.nixosModules.default
        ];
      };
    };

    # Nix-Darwin configuration entrypoint
    # Available through 'darwin-rebuild switch --flake .#mbp-14'
    darwinConfigurations = {
      "mbp-14" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          {nixpkgs.hostPlatform = "aarch64-darwin";}

          ./hosts/mbp-14/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit inputs outputs neovim;
              llamaCppPackage = nixpkgs.legacyPackages.aarch64-darwin.llama-cpp;
            };
            home-manager.users.wjkoh = {
              imports = [./hosts/mbp-14/home.nix];
              manual.html.enable = false;
            };
          }
        ];
      };
    };
  };
}
