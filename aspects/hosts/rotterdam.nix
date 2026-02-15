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

      # user aspects
      user
      root

      # Other aspects based on tags
      ai
      bluetooth
      dev
      fwupd
      gaming-flatpak
      gaming-hardware
      gaming-launchers
      gaming-steam
      libvirtd
      networkmanager
      niri
      podman
    ]);
  };
}
