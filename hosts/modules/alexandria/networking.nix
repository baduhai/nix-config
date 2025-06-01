{ ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        # 25565 # Minecraft
      ];
      allowedUDPPorts = [
        # 25565 # Minecraft
      ];
    };
  };
}
