{
  description = "My nix hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nur.url = "github:nix-community/nur";

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, kmonad, nixpkgs-stable, home-manager-stable, deploy-rs, agenix, ... }: {
    nixosConfigurations = {
      io = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktops/io.nix
          kmonad.nixosModules.default
          agenix.nixosModule
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./users/desktops/user.nix;
          }
          {
            nixpkgs.overlays = [
              nur.overlay
              agenix.overlay
            ];
          }
        ];
      };

      alexandria = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/servers/alexandria.nix
          agenix.nixosModule
          home-manager-stable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./users/servers/user.nix;
          }
        ];
      };
    };

    deploy = {
      autoRollback = false;
      magicRollback = false;
      user = "root";
      sshUser = "root";
      nodes = {
        alexandria = {
          hostname = "alexandria";
          profiles.system = {
            remoteBuild = true;
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.alexandria;
          };
        };
      };
    };
  };
}
