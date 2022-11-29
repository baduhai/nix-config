{ config, pkgs, lib, ... }:

{
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # Tailscale mail fail without this
    };
  };
}
