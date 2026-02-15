{ inputs, lib, ... }:
{
  flake.nixosConfigurations.trantor = inputs.nixpkgs-stable.lib.nixosSystem {
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

      # Factory-generated ephemeral module
      (inputs.self.factory.ephemeral {
        rootDevice = "/dev/disk/by-id/scsi-360b207ed25d84372a95d1ecf842f8e20-part2";
      })

      ((inputs.import-tree.initFilter (p: lib.hasSuffix ".nix" p)) ./_trantor)
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

      # Server aspects
      server-boot
      server-nix
      server-tailscale
    ]);
  };
}
