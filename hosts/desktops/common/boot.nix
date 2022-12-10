{ config, pkgs, lib, ... }:

{
  boot = {
    plymouth.enable = true;
    initrd.systemd.enable = true;
    loader.efi.efiSysMountPoint = "/boot/efi";
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    extraModprobeConfig = "options bluetooth disable_ertm=1";
    kernelModules = [
      "i2c-dev" # Required for arduino dev
      "i2c-piix4" # Required for arduino dev
    ];
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "udev.log_priority=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
    ];
  };
}
