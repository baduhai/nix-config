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
      # system aspects
      base
      cli
      server

      # user aspects
      user
      root

      # other aspects
      fwupd
      podman
    ]);
  };
}
