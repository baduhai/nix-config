{ inputs, config, pkgs, lib, ... }:

let
  modpack = (pkgs.fetchPackwizModpack {
    url =
      "https://raw.githubusercontent.com/baduhai/FFS/7d49a4209f1b13b23433079147340a5cad226f65/pack.toml";
    packHash = "";
  });
  mcVersion = modpack.manifest.versions.minecraft;
  fabricVersion = modpack.manifest.versions.fabric;
  serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";

in {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/data/minecraft";
    servers."seridor" = {
      enable = true;
      package = pkgs.fabricServers.${serverVersion}.override {
        loaderVersion = fabricVersion;
      };
      openFirewall = true;
      serverProperties = {
        difficulty = "hard";
        gamemode = "survival";
        motd = "Prominence II";
        online-mode = false;
        spawn-protection = false;
      };
      symlinks."mods" = "${modpack}/mods";
    };
  };
}
