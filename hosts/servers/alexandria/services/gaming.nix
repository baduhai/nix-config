{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    package = pkgs.papermc;
    serverProperties = {
      motd = "Bem-vindo a Alexandria";
      difficulty = "hard";
      gamemode = "survival";
    };
    dataDir = "/data/minecraft";
  };
}
