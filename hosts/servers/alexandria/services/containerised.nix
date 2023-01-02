{ inputs, config, pkgs, libs, ... }:

{
  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        "cinny" = {
          image = "ghcr.io/cinnyapp/cinny:latest";
          ports = [
            "8002:80"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "librespeed" = {
          image = "lscr.io/linuxserver/librespeed:latest";
          environment = {
            TZ = "Europe/Berlin";
          };
          ports = [
            "8003:80"
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
            TZ = "Europe/Berlin";
          };
          volumes = [
            "/data/syncthing/config:/config"
            "/data/syncthing/data1:/data1"
            "/data/syncthing/data2:/data2"
            "/data/syncthing/notes:/sync/notes"
          ];
          ports = [
            "8006:8384"
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
            "8007:5000"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
      };
    };
  };
}
