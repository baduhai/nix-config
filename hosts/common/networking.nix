{ inputs, config, pkgs, lib, ... }:

{
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # Tailscale may fail without this
    };
  };
}
