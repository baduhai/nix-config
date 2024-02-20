{
  description = "My nix hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    baduhai-nur.url = "github:baduhai/nur";

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

    yousable = {
      url = "github:t184256/yousable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, baduhai-nur, nixpkgs-stable
    , deploy-rs, agenix, nixos-generators, homepage, nix-minecraft, yousable
    , impermanence, ... }: {
      nixosConfigurations = {
        rotterdam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktops/rotterdam.nix
            agenix.nixosModules.default
            home-manager.nixosModules.default
            impermanence.nixosModules.impermanence
            {
              nixpkgs.overlays =
                [ baduhai-nur.overlay agenix.overlays.default ];
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
            {
              nixpkgs.overlays =
                [ baduhai-nur.overlay agenix.overlays.default ];
            }
          ];
        };

        alexandria = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/servers/alexandria.nix
            agenix.nixosModules.default
            yousable.nixosModules.default
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
      };

      homeConfigurations = {
        desktop = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./users/desktops/user.nix ];
        };

        server = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./users/servers/user.nix ];
        };
      };

      deploy = {
        autoRollback = true;
        magicRollback = false;
        nodes = {
          alexandria = {
            hostname = "alexandria";
            profilesOrder = [ "system" "user" ];
            profiles = {
              system = {
                user = "root";
                sshUser = "root";
                remoteBuild = true;
                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations.alexandria;
              };
              user = {
                user = "user";
                remoteBuild = true;
                path = deploy-rs.lib.x86_64-linux.activate.home-manager
                  self.homeConfigurations.server;
              };
            };
          };

          io = {
            hostname = "192.168.1.5";
            profilesOrder = [ "system" "user" ];
            profiles = {
              system = {
                user = "root";
                sshUser = "root";
                remoteBuild = true;
                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations.io;
              };
              user = {
                user = "user";
                remoteBuild = true;
                path = deploy-rs.lib.x86_64-linux.activate.home-manager
                  self.homeConfigurations.desktop;
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

      packages.x86_64-linux = {
        install-iso = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [{
            users.users.nixos.openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcwF1yuWEfYGScNocEbs0AmGxyTIzGc4/IhpU587SJE"
            ];
          }];
          format = "install-iso";
        };
      };
    };
}
