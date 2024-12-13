{
  description = "My nix hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homepage = {
      url = "github:AlexW00/StartTreeV2";
      flake = false;
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    stylix.url = "github:danth/stylix";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      home-manager-stable,
      agenix,
      deploy-rs,
      homepage,
      impermanence,
      nix-flatpak,
      nix-index-db,
      nix-minecraft,
      nixos-generators,
      stylix,
      ...
    }:
    {
      nixosConfigurations = {
        rotterdam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/desktops/rotterdam.nix
            agenix.nixosModules.default
            home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
            nix-index-db.nixosModules.nix-index
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix
            {
              nixpkgs.overlays = [
                agenix.overlays.default
                self.overlays.custom
              ];
            }
          ];
        };

        io = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/desktops/io.nix
            agenix.nixosModules.default
            home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
            nix-index-db.nixosModules.nix-index
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix
            {
              nixpkgs.overlays = [
                agenix.overlays.default
                self.overlays.custom
              ];
            }
          ];
        };

        alexandria = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/servers/alexandria.nix
            agenix.nixosModules.default
            home-manager-stable.nixosModules.default
            self.nixosModules.qbittorrent
            ({
              nixpkgs.overlays = [
                agenix.overlays.default
                nix-minecraft.overlay
              ];
              imports = [ nix-minecraft.nixosModules.minecraft-servers ];
            })
          ];
        };
      };

      overlays = {
        custom = final: prev: {
          chromeos-ectool =
            nixpkgs.legacyPackages."x86_64-linux".callPackage ./packages/chromeos-ectool.nix
              { };
          plasticity = nixpkgs.legacyPackages."x86_64-linux".callPackage ./packages/plasticity.nix { };
          creality-print =
            nixpkgs.legacyPackages."x86_64-linux".callPackage ./packages/creality-print.nix
              { };
        };
      };

      deploy = {
        autoRollback = true;
        magicRollback = false;
        nodes = {
          alexandria = {
            hostname = "alexandria";
            profiles = {
              system = {
                user = "root";
                sshUser = "root";
                remoteBuild = true;
                path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.alexandria;
              };
            };
          };

          io = {
            hostname = "io";
            profiles = {
              system = {
                user = "root";
                sshUser = "root";
                remoteBuild = false;
                path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.io;
              };
            };
          };
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      devShells."x86_64-linux".default = nixpkgs.legacyPackages."x86_64-linux".mkShell {
        packages = with nixpkgs.legacyPackages."x86_64-linux"; [
          nil
          nixfmt-rfc-style
        ];
      };

      nixosModules.qbittorrent = import ./modules/qbittorrent.nix;
    };
}
