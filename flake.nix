{
  description = "My nix hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, kmonad, nixpkgs-stable, home-manager-stable, deploy-rs, ... }: {
    nixosConfigurations = {
      io = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktops/io.nix
          kmonad.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ nur.overlay ];
          }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./users/desktops/user.nix;
          }
        ];
      };

      alexandria = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/servers/alexandria.nix
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
        "alexandria" = {
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
