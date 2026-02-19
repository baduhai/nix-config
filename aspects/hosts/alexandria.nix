{ inputs, ... }:

let
  mkHost = inputs.self.lib.mkHost;
in

{
  flake.nixosConfigurations.alexandria = mkHost {
    hostname = "alexandria";
    nixpkgs = inputs.nixpkgs-stable;
    extraModules = with inputs.self.modules.nixos; [
      # base aspects
      server
      # other aspects
      fwupd
      libvirtd
    ];
  };
}
