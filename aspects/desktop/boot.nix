{ inputs, ... }:
{
  flake.modules.nixos.desktop-boot = { config, lib, pkgs, ... }: {
    # Import parent aspect for inheritance
    imports = [ inputs.self.modules.nixos.common-boot ];

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
  };
}
