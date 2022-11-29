{
  description = "My nix hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, nur, kmonad, nixpkgs-stable, home-manager-stable, ... }: {
    nixosConfigurations = {
      io = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktops/io.nix
          kmonad.nixosModules.default
          { nixpkgs.overlays = [ nur.overlay ]; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./users/desktops/io/user.nix;
          }
        ];
      };

      alexandria = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/servers/alexandria/configuration.nix
          ( {...}: { nix.registry.nixpkgs.flake = nixpkgs-stable; } )
          home-manager-stable.nixosModules.home-manager
        ];
      };
    };
  };
}
