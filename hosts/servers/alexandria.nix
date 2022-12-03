{ config, pkgs, lib, ...}:

{
  imports = [
    # Host-specific imports
    ./alexandria/hardware-configuration.nix
    ./alexandria/hosted-services.nix
    # Host-common imports
    ../common/networking.nix
    ../common/packages.nix
    ../common/services.nix
    ../common/locale.nix
    ../common/users.nix
    ../common/boot.nix
    ../common/nix.nix
    # Server-common imports
    ./common/boot.nix
    ./common/nix.nix
  ];

  users.users.user.extraGroups = [ "docker" ];

  swapDevices = [ { device = "/swapfile"; size = 8192; } ];

  networking = {
    hostName = "alexandria";
    firewall = {
      allowedTCPPorts = [
        80
        443
        9666
      ];
    };
  };
}
