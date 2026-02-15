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
      # system aspects
      base
      cli
      desktop
      gaming

      # user aspects
      user
      root

      # other aspects
      ai
      bluetooth
      dev
      fwupd
      libvirtd
      networkmanager
      niri
      podman
    ]);
  };
}
