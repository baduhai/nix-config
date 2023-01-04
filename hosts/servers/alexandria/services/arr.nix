{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services = {
    transmission = {
      enable = true;
      group = "hosted";
      settings = {
        download-dir = "/data/torrent_storage/completed";
        incomplete-dir = "/data/torrent_storage/incomplete";
        incomplete-dir-enabled = true;
        rpc-authentication-required = false;
        rpc-host-whitelist-enabled = true;
        rpc-whitelist-enabled = true;
        peer-port = 57298;
        speed-limit-down = 5000;
        speed-limit-down-enabled = true;
        speed-limit-up = 500;
        speed-limit-up-enabled = true;
        alt-speed-down = 5000;
        alt-speed-enabled = false;
        alt-speed-time-begin = 240;
        alt-speed-time-day = 127;
        alt-speed-time-enabled = true;
        alt-speed-time-end = 480;
        alt-speed-up = 1500;
        utp-enabled = false;
      };
    };

    flood = {
      enable = true;
      user = "transmission";
      group = "hosted";
      port = "${config.ports.flood}";
    };

    jellyfin = {
      enable = true;
      group = "hosted";
    };

    radarr = {
      enable = true;
      group = "hosted";
    };

    sonarr = {
      enable = true;
      group = "hosted";
    };

    bazarr = {
      enable = true;
      group = "hosted";
    };

    prowlarr.enable = true;
  };
}
