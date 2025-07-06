{
  description = "My nix hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    disko = {
      url = "github:nix-community/disko?ref=v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/main";

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      home-manager-stable,
      stylix,
      disko,
      agenix,
      deploy-rs,
      nix-flatpak,
      impermanence,
      ...
    }:
    {
      nixosConfigurations =
        let
          mkHost =
            {
              hostname,
              type, # workstation|server
              system ? "x86_64-linux",
              extraModules ? [ ],
            }:
            let
              pkgs = if type == "server" then nixpkgs-stable else nixpkgs;
              hm = if type == "server" then home-manager-stable else home-manager;
              hostTypeFlags = {
                isServer = type == "server";
                isWorkstation = type == "workstation";
              };
              defaultModules = [
                ./hosts/${hostname}.nix
                agenix.nixosModules.default
                disko.nixosModules.default
                hm.nixosModules.default
                impermanence.nixosModules.impermanence
                nix-flatpak.nixosModules.nix-flatpak
                stylix.nixosModules.stylix
                {
                  nixpkgs.overlays = [
                    agenix.overlays.default
                  ];
                }
              ];
              workstationModules = [
                {
                  nixpkgs.overlays = [
                    self.overlays.workstationOverlay
                  ];
                }
              ];
              serverModules = [
                {
                  nixpkgs.overlays = [
                    self.overlays.serverOverlay
                  ];
                }
              ];
              typeModules = if type == "server" then serverModules else workstationModules;
              allModules = defaultModules ++ typeModules ++ extraModules;
            in
            pkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                inherit inputs;
                hostType = hostTypeFlags;
              };
              modules = allModules;
            };
        in
        {
          rotterdam = mkHost {
            hostname = "rotterdam";
            type = "workstation";
          };
          io = mkHost {
            hostname = "io";
            type = "workstation";
          };
          alexandria = mkHost {
            hostname = "alexandria";
            type = "server";
            extraModules = [
              self.nixosModules.qbittorrent
              self.nixosModules.rclone-webdav
            ];
          };
          trantor = mkHost {
            hostname = "trantor";
            type = "server";
            system = "aarch64-linux";
          };
        };

      overlays = {
        overlay = final: prev: {
        };
        workstationOverlay = final: prev: {
          plasticity = nixpkgs.legacyPackages."x86_64-linux".callPackage ./packages/plasticity.nix { };
          toggleaudiosink =
            nixpkgs.legacyPackages."x86_64-linux".callPackage ./packages/toggleaudiosink.nix
              { };
        };
        serverOverlay = final: prev: {
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

          # trantor = {
          #   hostname = "trantor";
          #   profiles = {
          #     system = {
          #       user = "root";
          #       sshUser = "root";
          #       remoteBuild = true;
          #       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.alexandria;
          #     };
          #   };
          # };

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

      nixosModules = {
        qbittorrent = import ./modules/qbittorrent.nix;
        rclone-webdav = import ./modules/rclone-webdav.nix;
      };
    };
}
