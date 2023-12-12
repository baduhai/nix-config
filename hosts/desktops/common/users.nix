{ inputs, config, pkgs, lib, ... }:

{
  environment.sessionVariables = rec {
    KDEHOME =
      "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
    NIXOS_OZONE_WL =
      "1"; # Forces chromium and most electron apps to run in wayland
  };

  users.users.user = {
    description = "William";
    extraGroups = [
      "uaccess" # Needed for HID dev
      "dialout" # Needed for arduino dev
      "libvirt"
      "libvirtd"
      "adbusers"
      "i2c"
    ];
  };
}
