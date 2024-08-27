{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd = {
    availableKernelModules =
      [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
    kernelModules = [ "nvme" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/sda4";
      fsType = "xfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/14EF-4002";
      fsType = "vfat";
    };
  };
}
