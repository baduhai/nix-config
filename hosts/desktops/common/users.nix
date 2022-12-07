{ config, pkgs, lib, ... }:

{
  environment.sessionVariables = rec {
    KDEHOME = "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
    DICPATH = "/run/current-system/sw/share/hunspell"; # hunspell doesn't export its path for some reason
  };

  users.users.user = {
    description = "William";
    extraGroups = [
      "uaccess" # Needed for HID dev
      "dialout" # Needed for arduino dev
      "libvirtd"
      "adbusers"
    ];
  };
}
