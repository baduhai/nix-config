{ inputs, config, pkgs, lib, ... }:

let
  modpack = pkgs.fetchPackwizModpack {
    url =
      "https://raw.githubusercontent.com/baduhai/FFS/06d253f0cd262b8d4a178d4db8e1a7188051e8d0/pack.toml";
    packHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
  };
  mcVersion = modpack.manifest.versions.minecraft;
  fabricVersion = modpack.manifest.versions.fabric;
  serverVersion =
    lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}-${fabricVersion}";

in {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/data/minecraft";
    servers."seridor" = {
      enable = true;
      package = pkgs.fabricServers.${serverVersion};
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
