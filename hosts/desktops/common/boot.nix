{ inputs, config, pkgs, lib, ... }:

{
  boot = {
    plymouth = {
      enable = true;
      themePackages = with pkgs; [ adi1090x-plymouth-themes ];
      theme = "colorful_sliced";
    };
    initrd.systemd.enable = true;
    loader = {
      efi.efiSysMountPoint = "/boot/efi";
      systemd-boot = {
        sortKey = "aa";
        netbootxyz = {
          enable = true;
          sortKey = "zz";
        };
      };
    };
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    extraModprobeConfig = ''
      options bluetooth disable_ertm=1
    '';
    kernel.sysctl = { "net.ipv4.tcp_mtu_probing" = 1; };
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
}
