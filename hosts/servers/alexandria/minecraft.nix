{ inputs, config, pkgs, lib, ... }:

let
  modpack = (pkgs.fetchPackwizModpack {
    url =
      "https://raw.githubusercontent.com/baduhai/FFS/000a28196d5ec5e90222d69cfadb97311bb6f2c3/pack.toml";
    packHash = "sha256-EHL/rCkqcRzVvvnDZsP2s7S30ZBsG9r9L4Tn1dzjzWM=";
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
        motd = "O Seridor";
        online-mode = false;
        spawn-protection = false;
      };
      symlinks."mods" = "${modpack}/mods";
    };
  };
}
