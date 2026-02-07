{ inputs, ... }:
{
  flake.nixosConfigurations.io = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.agenix.nixosModules.default
      { networking.hostName = "io"; }
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

      # Desktop aspects
      inputs.self.modules.nixos.desktop-boot
      inputs.self.modules.nixos.desktop-desktop
      inputs.self.modules.nixos.desktop-nix
      inputs.self.modules.nixos.desktop-services

      # Other aspects based on tags
      inputs.self.modules.nixos.ai
      inputs.self.modules.nixos.bluetooth
      inputs.self.modules.nixos.dev
      inputs.self.modules.nixos.libvirtd
      inputs.self.modules.nixos.networkmanager
      inputs.self.modules.nixos.podman

      # Factory-generated ephemeral module
      (inputs.self.factory.ephemeral {
        rootDevice = "/dev/mapper/cryptroot";
      })

      # Host-specific files (from _io/)
      ./_io/hardware-configuration.nix
      ./_io/disko.nix
      ./_io/boot.nix
      ./_io/programs.nix
      ./_io/services.nix
    ];
  };
}
