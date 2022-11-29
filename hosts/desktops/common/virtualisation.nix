{ config, pkgs, lib, ... }:

{
  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true; # Baisically aliases docker to podman
    };
  };
}
