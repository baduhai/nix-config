{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings = { dns_enabled = true; };
  };
}
