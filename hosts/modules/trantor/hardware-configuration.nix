{
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    kernelModules = [ ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "usbhid"
      ];
      kernelModules = [ ];
    };
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
