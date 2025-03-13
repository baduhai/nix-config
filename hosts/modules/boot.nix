{
  hostType,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      boot = {
        loader = {
          timeout = 1;
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

    # Server specific configuration
    (lib.mkIf hostType.isServer {
      boot.kernelPackages = pkgs.linuxPackages_hardened;
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
      boot = {
        plymouth.enable = true;
        initrd.systemd.enable = true;
        loader.efi.efiSysMountPoint = "/boot/efi";
        kernelPackages = pkgs.linuxPackages_xanmod_latest;
        extraModprobeConfig = ''
          options bluetooth disable_ertm=1
        '';
        kernel.sysctl = {
          "net.ipv4.tcp_mtu_probing" = 1;
        };
        kernelParams = [
          "quiet"
          "splash"
          "i2c-dev"
          "i2c-piix4"
          "loglevel=3"
          "udev.log_priority=3"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=false"
        ];
      };
    })
  ];
}
