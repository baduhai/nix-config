{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
    lxd.enable = true;
    docker.enable = true;
  };
}
