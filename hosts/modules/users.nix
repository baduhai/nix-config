{
  hostType,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      users.users = {
        user = {
          isNormalUser = true;
          shell = pkgs.fish;
          extraGroups = [
            "networkmanager"
            "docker"
            "wheel"
          ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL user@rotterdam"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Y0PVpGfJHonqDS7qoCFhqzUvqGq9I9sax+F9e/5cs user@io"
          ];
          hashedPassword = "$6$Pj7v/CpstyuWQQV0$cNujVDhfMBdwlGVEnnd8t71.kZPixbo0u25cd.874iaqLTH4V5fa1f98V5zGapjQCz5JyZmsR94xi00sUrntT0";
        };
        root = {
          shell = pkgs.fish;
          hashedPassword = "!";
        };
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bkp";
        users = {
          user = import ../../users/user.nix;
          root = import ../../users/root.nix;
        };
        sharedModules = [
          inputs.nixvim.homeModules.nixvim
        ];
        extraSpecialArgs = {
          inherit hostType;
          inherit inputs;
        };
      };
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
      environment.sessionVariables = {
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
    })
  ];
}
