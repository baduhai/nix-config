{ inputs, self, ... }:
{
  flake.nixosConfigurations.alexandria = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.agenix.nixosModules.default
      { networking.hostName = "alexandria"; }
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

      # Other aspects based on tags
      inputs.self.modules.nixos.fwupd

      # Host-specific files (from _alexandria/)
      ./_alexandria/hardware-configuration.nix
      ./_alexandria/jellyfin.nix
      ./_alexandria/kanidm.nix
      ./_alexandria/nextcloud.nix
      ./_alexandria/nginx.nix
      ./_alexandria/unbound.nix
      ./_alexandria/vaultwarden.nix
    ];
  };
}
