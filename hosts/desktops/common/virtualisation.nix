{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  virtualisation = {
    libvirtd.enable = true;
    lxd.enable = true;
  };
}
