{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
      luks.devices."enc".device =
        "/dev/disk/by-uuid/8018720e-42dd-453c-b374-adaa02eb48c9";
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3638cea6-5503-43cc-aa4f-3d37ebedad2f";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/3638cea6-5503-43cc-aa4f-3d37ebedad2f";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/3638cea6-5503-43cc-aa4f-3d37ebedad2f";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/3638cea6-5503-43cc-aa4f-3d37ebedad2f";
      fsType = "btrfs";
      options = [ "subvol=@persistent" ];
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/34AD-002A";
      fsType = "vfat";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}

