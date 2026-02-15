{ inputs, lib, ... }:

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
      ((inputs.import-tree.initFilter (p: lib.hasSuffix ".nix" p)) ./_alexandria)
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

      # Other aspects
      fwupd
    ]);
  };
}
