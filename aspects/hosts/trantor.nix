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
      ((inputs.import-tree.initFilter (p: lib.hasSuffix ".nix" p)) ./_trantor)
      (inputs.self.factory.ephemeral {
        rootDevice = "/dev/disk/by-id/scsi-360b207ed25d84372a95d1ecf842f8e20-part2";
      })
    ]
    ++ (with inputs.self.modules.nixos; [
      # system aspects
      base
      cli
      server

      # user aspects
      user
      root
    ]);
  };
}
