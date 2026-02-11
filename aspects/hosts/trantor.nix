{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations.trantor = inputs.nixpkgs-stable.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        inputs.agenix.nixosModules.default
        { networking.hostName = "trantor"; }
        {
          nixpkgs.overlays = [
            inputs.agenix.overlays.default
            inputs.self.overlays.default
          ];
        }

        # Common aspects (always included)
        inputs.self.modules.nixos.common-boot
        inputs.self.modules.nixos.common-console
        inputs.self.modules.nixos.common-firewall
        inputs.self.modules.nixos.common-locale
        inputs.self.modules.nixos.common-nix
        inputs.self.modules.nixos.common-openssh
        inputs.self.modules.nixos.common-programs
        inputs.self.modules.nixos.common-security
        inputs.self.modules.nixos.common-services
        inputs.self.modules.nixos.common-tailscale

        # User aspects
        inputs.self.modules.nixos.user
        inputs.self.modules.nixos.root

        # Server aspects
        inputs.self.modules.nixos.server-boot
        inputs.self.modules.nixos.server-nix
        inputs.self.modules.nixos.server-tailscale

        # Factory-generated ephemeral module
        (inputs.self.factory.ephemeral {
          rootDevice = "/dev/disk/by-id/scsi-360b207ed25d84372a95d1ecf842f8e20-part2";
        })

        # Host-specific files (from _trantor/)
        ./_trantor/hardware-configuration.nix
        ./_trantor/disko.nix
        ./_trantor/boot.nix
        ./_trantor/fail2ban.nix
        ./_trantor/forgejo.nix
        ./_trantor/networking.nix
        ./_trantor/nginx.nix
        ./_trantor/openssh.nix
        ./_trantor/unbound.nix
      ];
    };
    deploy.nodes.trantor = {
      hostname = "trantor";
      profiles.system = {
        sshUser = "user";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.trantor;
        user = "root";
      };
    };
  };
}
