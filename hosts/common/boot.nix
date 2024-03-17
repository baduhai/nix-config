{ inputs, config, pkgs, lib, ... }:

{
  boot = {
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        netbootxyz.enable = true;
      };
    };
  };
}
