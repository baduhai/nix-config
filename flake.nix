{
  description = "My nix hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = { url = "github:nix-community/home-manager/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager-stable = { url = "github:nix-community/home-manager/release-22.11"; inputs.nixpkgs.follows = "nixpkgs-stable"; };

    nur.url = "github:nix-community/nur";

    kmonad = { url = "github:kmonad/kmonad?dir=nix"; inputs.nixpkgs.follows = "nixpkgs"; };

    deploy-rs = { url = "github:serokell/deploy-rs"; inputs.nixpkgs.follows = "nixpkgs"; };

    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };

    nixos-generators = { url = "github:nix-community/nixos-generators"; inputs.nixpkgs.follows = "nixpkgs-stable"; };

    homepage = { url = "github:baduhai/homepage"; flake = false; };

    dotfiles = { url = "github:baduhai/dotfiles"; flake = false; };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, kmonad, nixpkgs-stable, home-manager-stable, deploy-rs, agenix, nixos-generators, homepage, dotfiles, ... }: {
    nixosConfigurations = {
      io = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktops/io.nix
          kmonad.nixosModules.default
          agenix.nixosModule
          home-manager.nixosModules.home-manager
          { nixpkgs.overlays = [ nur.overlay agenix.overlay ]; }
        ];
      };

      alexandria = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/servers/alexandria.nix
          agenix.nixosModule
          home-manager-stable.nixosModules.home-manager
          self.nixosModules.qbittorrent
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

    nixosModules.qbittorrent = import ./modules/qbittorrent.nix;

    packages.x86_64-linux = {
      install-iso = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          {users.users.nixos.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcwF1yuWEfYGScNocEbs0AmGxyTIzGc4/IhpU587SJE" ];}
        ];
        format = "install-iso";
      };
    };
  };
}
