{ ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [
        25565
        19132
      ];
    };
    nat = {
      enable = true;
      externalInterface = "enp0s6";
      internalInterfaces = [ "tailscale0" ];
      externalIP = null;
      forwardPorts = [
        {
          sourcePort = 25565;
          proto = "tcp";
          destination = "100.76.19.50:25565";
        }
        {
          sourcePort = 25565;
          proto = "udp";
          destination = "100.76.19.50:25565";
        }
        {
          sourcePort = 19132;
          proto = "udp";
          destination = "100.76.19.50:19132";
        }
      ];
    };
  };
}
