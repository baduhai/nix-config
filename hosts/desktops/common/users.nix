{ ... }:

{
  environment.sessionVariables = rec {
    KDEHOME = "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
    NIXOS_OZONE_WL = "1"; # Forces chromium and most electron apps to run in wayland
  };

  users.users = {
    user = {
      description = "William";
      uid = 1000;
      extraGroups = [
        "uaccess" # Needed for HID dev
        "dialout" # Needed for arduino dev
        "libvirt"
        "libvirtd"
        "adbusers"
        "i2c"
      ];
    };
    ewans = {
      description = "Ewans";
      isNormalUser = true;
      uid = 1001;
      hashedPassword = "$y$j9T$yHLUDvj6bDIP19dchU.aA/$OY4qeFNtx/GvI.VUYx4LapHiiVwi0MEvs8AT0HN7j58";
    };
  };
}
