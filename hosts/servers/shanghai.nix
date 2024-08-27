{ ... }:

{
  imports = [
    # Host-common imports
    ../common
    # Server-common imports
    ./common
    # Host-specific imports
    ./shanghai
  ];

  nix.nixPath = [ "nixos-config=${./shanghai.nix}" ];

  networking = {
    hostName = "shanghai";
    firewall = {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 25565 ];
    };
    nftables.enable = true;
  };

  zramSwap.enable = true;
}
