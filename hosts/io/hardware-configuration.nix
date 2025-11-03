{
  config,
  lib,
  modulesPath,
  inputs,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ] ++ inputs.self.diskoConfigurations.io.modules;

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
    };
    kernelModules = [ "kvm-intel" ];
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
