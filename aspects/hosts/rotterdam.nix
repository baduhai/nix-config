{ inputs, lib, ... }:

{
  flake.nixosConfigurations.rotterdam = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.agenix.nixosModules.default
      { networking.hostName = "rotterdam"; }
      {
        nixpkgs.overlays = [
          inputs.agenix.overlays.default
          inputs.self.overlays.default
        ];
      }
      ((inputs.import-tree.initFilter (p: lib.hasSuffix ".nix" p)) ./_rotterdam)
      (inputs.self.factory.ephemeral {
        rootDevice = "/dev/mapper/cryptroot";
      })
    ]
    ++ (with inputs.self.modules.nixos; [
      cli

      # Common aspects (always included)
      common-boot
      common-console
      common-firewall
      common-locale
      common-nix
      common-openssh
      common-programs
      common-security
      common-services
      common-tailscale

      # User aspects
      user
      root

      # Desktop aspects
      desktop-boot
      desktop-desktop
      desktop-nix
      desktop-services

      # Other aspects based on tags
      ai
      bluetooth
      dev
      fwupd
      gaming-steam
      gaming-hardware
      gaming-flatpak
      gaming-launchers
      libvirtd
      networkmanager
      podman
    ]);
  };
}
