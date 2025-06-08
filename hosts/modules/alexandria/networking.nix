{ ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ ];
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
