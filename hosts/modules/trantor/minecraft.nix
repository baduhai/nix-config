{ pkgs, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    servers.fabric = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_5;
      jvmOpts = "-Xms2G -Xmx8G";
      openFirewall = true;
      serverProperties = {
        server-port = 25566;
        difficulty = "hard";
        gamemode = "survival";
        white-list = true;
        motd = "Servidor dos primos";
      };
    };
  };
}
