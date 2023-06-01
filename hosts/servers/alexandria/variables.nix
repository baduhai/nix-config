{ inputs, config, pkgs, lib, ... }:

let
  mkStringOption = default:
    lib.mkOption {
      inherit default;
      type = lib.types.str;
    };

in {
  options.ports = {
    n8n = mkStringOption "5678";
    bazaar = mkStringOption "6767";
    radarr = mkStringOption "7878";
    vaultwarden = mkStringOption "8000";
    changedetection-io = mkStringOption "8001";
    cinny = mkStringOption "8002";
    librespeed = mkStringOption "8003";
    paperless = mkStringOption "8004";
    shiori = mkStringOption "8005";
    cinny2 = mkStringOption "8006";
    searx = mkStringOption "8007";
    qbittorrent = mkStringOption "8008";
    actual = mkStringOption "8009";
    big-agi = mkStringOption "8010";
    jellyfin = mkStringOption "8096";
    sonarr = mkStringOption "8989";
    jackett = mkStringOption "9117";
  };
}
