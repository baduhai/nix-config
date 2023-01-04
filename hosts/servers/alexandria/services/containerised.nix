{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        "cinny" = {
          image = "ghcr.io/cinnyapp/cinny:latest";
          ports = [
            "${config.ports.cinny}:80"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "librespeed" = {
          image = "lscr.io/linuxserver/librespeed:latest";
          environment = {
            TZ = "America/Bahia";
          };
          ports = [
            "${config.ports.librespeed}:80"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "qflood" = {
          image = "cr.hotio.dev/hotio/qflood";
          environment = {
            PUID = "1000";
            PGID = "100";
            UMASK = "002";
            TZ = "America/Bahia";
            FLOOD_AUTH = "false";
          };
          volumes = [
            "/data/qflood:/config"
          ];
          ports = [
            "${config.ports.flood}:3000"
            "${config.ports.qbittorrent}:8080"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "syncthing" = {
          image = "lscr.io/linuxserver/syncthing:1.20.4";
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "America/Bahia";
          };
          volumes = [
            "/data/syncthing/config:/config"
            "/data/syncthing/data1:/data1"
            "/data/syncthing/data2:/data2"
            "/data/syncthing/notes:/sync/notes"
          ];
          ports = [
            "${config.ports.syncthing}:8384"
            "22000:22000"
            "21027:21027/udp"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "whoogle" = {
          image = "benbusby/whoogle-search:latest";
          environment = {
            HTTPS_ONLY = "1";
            WHOOGLE_CONFIG_DISABLE = "1";
            WHOOGLE_CONFIG_LANGUAGE = "lang_en";
            WHOOGLE_CONFIG_THEME = "system";
            WHOOGLE_CONFIG_VIEW_IMAGE = "1";
            WHOOGLE_CONFIG_GET_ONLY = "1";
          };
          ports = [
            "${config.ports.whoogle}:5000"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
      };
    };
  };
}
