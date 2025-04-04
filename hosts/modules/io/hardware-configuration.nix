{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      luks.devices."enc" = {
        device = "/dev/disk/by-uuid/8018720e-42dd-453c-b374-adaa02eb48c9";
        keyFile = "/dev/disk/by-partuuid/cbc7e305-d32d-4250-b6ae-6a8264ea096e";
      };
    };
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3638cea6-5503-43cc-aa4f-3d37ebedad2f";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "noatime"
        "compress=zstd"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/3638cea6-5503-43cc-aa4f-3d37ebedad2f";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/3638cea6-5503-43cc-aa4f-3d37ebedad2f";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "compress=zstd"
      ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/3638cea6-5503-43cc-aa4f-3d37ebedad2f";
      fsType = "btrfs";
      options = [
        "subvol=@persistent"
        "noatime"
        "compress=zstd"
      ];
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/31C9-08FF";
      fsType = "vfat";
      options = [
        "noatime"
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
