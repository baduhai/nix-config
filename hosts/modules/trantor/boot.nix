{
  boot = {
    loader.efi.efiSysMountPoint = "/boot";
    initrd.systemd.enable = true;
    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };
}
