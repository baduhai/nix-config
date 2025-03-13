{ ... }:

{
  networking = {
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
