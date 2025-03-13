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
        "amdgpu"
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      luks.devices."cryptroot" = {
        device = "/dev/disk/by-uuid/f7dd4142-7109-4493-834d-4a831777f08d";
        keyFile = "/dev/disk/by-partuuid/add5fc14-e20f-48be-8b2a-0799ef04d3cb";
      };
    };
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3287dbc3-c0fa-4096-a0b3-59b017cfecc8";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "noatime"
        "compress=zstd"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/3287dbc3-c0fa-4096-a0b3-59b017cfecc8";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd"
      ];
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/F2A2-CF5A";
      fsType = "vfat";
      options = [
        "noatime"
        "fmask=0077"
        "dmask=0077"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/3287dbc3-c0fa-4096-a0b3-59b017cfecc8";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "compress=zstd"
      ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/3287dbc3-c0fa-4096-a0b3-59b017cfecc8";
      fsType = "btrfs";
      options = [
        "subvol=@persistent"
        "noatime"
        "compress=zstd"
      ];
    };
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
