{
  lib,
  modulesPath,
  self,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    self.diskoConfigurations.trantor
  ];

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
}
