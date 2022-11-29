{ config, pkgs, lib, ...}:

{
  imports = [
    ./hardware-configuration.nix
    ./hosted-services.nix
    ./packages.nix
    ./users.nix
    <home-manager/nixos>
  ];

  swapDevices = [ { device = "/swapfile"; size = 8192; } ];
  
  boot = {
    kernelPackages = pkgs.linuxPackages_hardened;
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "alexandria";
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedTCPPorts = [
        80
        443
        9666
      ];
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IE.UTF-8";
      LC_IDENTIFICATION = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_NAME = "en_IE.UTF-8";
      LC_NUMERIC = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
      LC_TELEPHONE = "en_IE.UTF-8";
      LC_TIME = "en_IE.UTF-8";
    };
  };

  services = {
    openssh.enable = true;
    tailscale.enable = true;
    fstrim.enable = true;
  };

  nix = {
    settings.auto-optimise-store = true;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 8d";
    };
  };
  
  system = {
    stateVersion = "22.05";
    autoUpgrade = {
      enable = true;
      dates = "weekly";
      allowReboot = true;
    };
  };
}
