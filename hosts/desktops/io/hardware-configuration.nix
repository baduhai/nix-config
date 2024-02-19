{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
      luks.devices."cryptroot".device =
        "/dev/disk/by-uuid/37c930c5-2b31-4d18-a1c4-7f13e0412656";
    };
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by_uuid/ef1916a9-e15c-450e-8100-4b2af9f6e1a5";
      fsType = "btrfs";
      options = [ "subvol=@root" "noatime" "compress=zstd" ];
    };
    "/home" = {
      device = "/dev/disk/by_uuid/ef1916a9-e15c-450e-8100-4b2af9f6e1a5";
      fsType = "btrfs";
      options = [ "subvol=@home" "noatime" "compress=zstd" ];
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/36B4-C473";
      fsType = "vfat";
      options = [ "noatime" "fmask=0077" "dmask=0077" ];
    };
    "/nix" = {
      device = "/dev/disk/by_uuid/ef1916a9-e15c-450e-8100-4b2af9f6e1a5";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" "compress=zstd" ];
    };
    "/persistent" = {
      device = "/dev/disk/by_uuid/ef1916a9-e15c-450e-8100-4b2af9f6e1a5";
      fsType = "btrfs";
      options = [ "subvol=@persistent" "noatime" "compress=zstd" ];
    };
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
