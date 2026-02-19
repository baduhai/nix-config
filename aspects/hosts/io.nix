{ inputs, ... }:

let
  mkHost = inputs.self.lib.mkHost;
in

{
  flake.nixosConfigurations.io = mkHost {
    hostname = "io";
    ephemeralRootDev = "/dev/mapper/cryptroot";
    extraModules = with inputs.self.modules.nixos; [
      # base aspects
      desktop
      # other aspects
      ai
      bluetooth
      dev
      libvirtd
      networkmanager
      niri
      podman
    ];
  };
}
