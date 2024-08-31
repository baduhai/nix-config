{
  description = "My nix hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    homepage = {
      url = "github:AlexW00/StartTreeV2";
      flake = false;
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixpkgs-stable, deploy-rs
    , agenix, nixos-generators, homepage, nix-minecraft, impermanence
    , nix-index-db, ... }: {
      nixosConfigurations = {
        rotterdam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktops/rotterdam.nix
            agenix.nixosModules.default
            home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
            nix-index-db.nixosModules.nix-index
            {
              nixpkgs.overlays =
                [ agenix.overlays.default self.overlays.custom ];
            }
          ];
        };

        io = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktops/io.nix
            agenix.nixosModules.default
            home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
            nix-index-db.nixosModules.nix-index
            {
              nixpkgs.overlays =
                [ agenix.overlays.default self.overlays.custom ];
            }
          ];
        };

        alexandria = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/servers/alexandria.nix
            agenix.nixosModules.default
            self.nixosModules.qbittorrent
            ({ config, pkgs, ... }:
              let
                unstable-overlay = final: prev: {
                  unstable = nixpkgs.legacyPackages.x86_64-linux;
                };
              in {
                nixpkgs.overlays = [
                  unstable-overlay
                  agenix.overlays.default
                  nix-minecraft.overlay
                ];
                imports = [ nix-minecraft.nixosModules.minecraft-servers ];
              })
          ];
        };

        shanghai = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/servers/shanghai.nix
            agenix.nixosModules.default
            self.nixosModules.qbittorrent
            ({ config, pkgs, ... }:
              let
                unstable-overlay = final: prev: {
                  unstable = nixpkgs.legacyPackages.x86_64-linux;
                };
              in {
                nixpkgs.overlays = [ unstable-overlay agenix.overlays.default ];
                imports = [ ];
              })
          ];
        };
      };

      # homeConfigurations = {
      #   desktop = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #     extraSpecialArgs = { inherit inputs; };
      #     modules = [ ./users/desktops/user.nix ];
      #   };

      #   server = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #     extraSpecialArgs = { inherit inputs; };
      #     modules = [ ./users/servers/user.nix ];
      #   };
      # };

      packages."x86_64-linux" = {
        chromeos-ectool = nixpkgs.legacyPackages."x86_64-linux".callPackage
          ./packages/chromeos-ectool.nix { };
      };

      overlays = {
        custom = final: prev: {
          inherit (self.packages."x86_64-linux") chromeos-ectool;
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
                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations.alexandria;
              };
            };
          };

          shanghai = {
            hostname = "shanghai";
            profiles = {
              system = {
                user = "root";
                sshUser = "root";
                remoteBuild = true;
                plath = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations.shanghai;
              };
            };
          };

          io = {
            hostname = "io";
            profiles = {
              system = {
                user = "root";
                sshUser = "root";
                remoteBuild = true;
                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations.io;
              };
            };
          };
        };
      };

      devShells = {
        "x86_64-linux".default = nixpkgs.legacyPackages."x86_64-linux".mkShell {
          packages = with nixpkgs.legacyPackages."x86_64-linux"; [ nil nixfmt ];
        };
        "aarch64-linux".default =
          nixpkgs.legacyPackages."aarch64-linux".mkShell {
            packages = with nixpkgs.legacyPackages."aarch64-linux"; [
              nil
              nixfmt
            ];
          };
      };

      nixosModules.qbittorrent = import ./modules/qbittorrent.nix;
    };
}
