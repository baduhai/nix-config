{ ... }:

{
  imports = [
    ./modules
    ./alexandria
  ];

  nix.nixPath = [ "nixos-config=${./alexandria.nix}" ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  networking = {
    hostName = "alexandria";
    firewall = {
      allowedTCPPorts = [
        80
        443
        8010
        9666
      ];
      allowedUDPPorts = [ 24454 ];
    };
  };
}
