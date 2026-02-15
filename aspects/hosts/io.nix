{ inputs, lib, ... }:

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
      ((inputs.import-tree.initFilter (p: lib.hasSuffix ".nix" p)) ./_io)
      (inputs.self.factory.ephemeral {
        rootDevice = "/dev/mapper/cryptroot";
      })
    ]
    ++ (with inputs.self.modules.nixos; [
      # system aspects
      base
      cli
      desktop

      # user aspects
      user
      root

      # Other aspects
      ai
      bluetooth
      dev
      libvirtd
      networkmanager
      niri
      podman
    ]);
  };
}
