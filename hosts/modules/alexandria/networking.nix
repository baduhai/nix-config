{ ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        25565 # Minecraft
      ];
      allowedUDPPorts = [
        24454 # Minecraft Simple Voice Chat
        25565 # Minecraft
      ];
    };
  };
}
