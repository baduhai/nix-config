{ inputs, config, pkgs, lib, ... }:

let
  modpack = (pkgs.fetchPackwizModpack {
    url =
      "https://raw.githubusercontent.com/baduhai/FFS/11a82acc9c67929f2130e03e3fc397a11d9cd809/pack.toml";
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
        motd = "Another RPG";
        online-mode = false;
        spawn-protection = false;
      };
      symlinks."mods" = "${modpack}/mods";
    };
  };
}
