{ inputs, ... }:

let
  mkHost = inputs.self.lib.mkHost;
in

{
  flake.nixosConfigurations.rotterdam = mkHost {
    hostname = "rotterdam";
    ephemeralRootDev = "/dev/mapper/cryptroot";
    extraModules = with inputs.self.modules.nixos; [
      # base aspects
      desktop
      gaming
      # other aspects
      ai
      bluetooth
      dev
      fwupd
      libvirtd
      networkmanager
      niri
      podman
    ];
  };
}
