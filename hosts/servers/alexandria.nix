{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    # Host-common imports
    ../common
    # Server-common imports
    ./common
    # Host-specific imports
    ./alexandria
  ];

  nix.nixPath = [ "nixos-config=${./alexandria.nix}" ];

  swapDevices = [{
    device = "/swapfile";
    size = 8192;
  }];

  networking = {
    hostName = "alexandria";
    firewall = {
      allowedTCPPorts = [ 80 443 8010 9666 ];
      allowedUDPPorts = [ 24454 ];
    };
  };
}
