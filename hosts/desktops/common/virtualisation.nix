{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
    lxd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true; # Baisically aliases docker to podman
    };
  };
}
