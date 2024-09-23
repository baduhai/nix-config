{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  boot = {
    loader = {
      timeout = 2;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
        sortKey = "aa";
        netbootxyz = {
          enable = true;
          sortKey = "zz";
        };
      };
    };
  };
}
