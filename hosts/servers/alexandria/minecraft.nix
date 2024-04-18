{ inputs, config, pkgs, lib, ... }:

let
  modpack = (pkgs.fetchPackwizModpack {
    url =
      "https://raw.githubusercontent.com/baduhai/FFS/9544cadf6700c0a3eb743888150c5dfb971641a3/pack.toml";
    packHash = "sha256-JXqyRnfz10RQPYrXUFpg/T8F9eT7y+/LTflIWMrRHS8=";
  });
  mcVersion = modpack.manifest.versions.minecraft;
  fabricVersion = modpack.manifest.versions.fabric;
  serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";

in {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/data/minecraft";
    servers."expansion" = {
      enable = true;
      package = pkgs.fabricServers.${serverVersion}.override {
        loaderVersion = fabricVersion;
      };
      openFirewall = true;
      serverProperties = {
        difficulty = "hard";
        gamemode = "survival";
        motd = "Expansion";
        online-mode = false;
        spawn-protection = false;
      };
      symlinks."mods" = "${modpack}/mods";
    };
  };
}
