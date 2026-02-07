{
  boot = {
    initrd.systemd.enable = true;
    loader.efi.efiSysMountPoint = "/boot/efi";
  };
}
