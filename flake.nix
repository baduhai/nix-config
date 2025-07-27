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

    disko = {
      url = "github:nix-community/disko?ref=v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixos-cli.url = "github:nix-community/nixos-cli";

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
      nixos-cli,
      nix-flatpak,
      impermanence,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      forAllSystemsWithPkgs =
        f:
        forAllSystems (
          system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          f system pkgs
        );
    in
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
                nixos-cli.nixosModules.nixos-cli
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
            ];
          };
          trantor = mkHost {
            hostname = "trantor";
            type = "server";
            system = "aarch64-linux";
          };
        };

      devShells = forAllSystemsWithPkgs (
        system: pkgs: {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nil
              nixfmt-rfc-style
            ];
          };
        }
      );

      packages = forAllSystemsWithPkgs (
        system: pkgs:
        {
          toggleaudiosink = pkgs.callPackage ./packages/toggleaudiosink.nix { };
        }
        // nixpkgs.lib.optionalAttrs (system == "x86_64-linux") {
          plasticity = pkgs.callPackage ./packages/plasticity.nix { };
        }
      );

      overlays = {
        overlay = final: prev: {
        };
        workstationOverlay = final: prev: {
          plasticity = self.packages.${final.system}.plasticity;
          toggleaudiosink = self.packages.${final.system}.toggleaudiosink;
        };
        serverOverlay = final: prev: {
        };
      };

      nixosModules = {
        qbittorrent = import ./modules/qbittorrent.nix;
      };
    };
}
