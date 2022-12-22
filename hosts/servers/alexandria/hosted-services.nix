{ inputs, config, pkgs, libs, ... }:

{
  users.users.nginx.extraGroups = [ "acme" ];

  services = {
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; root = inputs.homepage; };
        "detect.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8001/"; };
        "cinny.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8002/"; };
        "jellyfin.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8003/"; };
        "librespeed.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8004/"; };
        "paperless.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8005/"; };
        "pyload.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8006/"; };
        "shiori.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8007/"; };
        "sync.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8008/"; };
        "whoogle.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8009/"; };
#         ".baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:80/"; };
      };
    };
  };

  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        "changedetection" = {
          image = "lscr.io/linuxserver/changedetection.io:latest";
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "Europe/Berlin";
            BASE_URL = "detect.baduhai.me";
          };
          volumes = [
            "/data/changedetection:/config"
          ];
          ports = [
            "8001:5000"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "cinny" = {
          image = "ghcr.io/cinnyapp/cinny:latest";
          ports = [
            "8002:80"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "jellyfin" = {
          image = "lscr.io/linuxserver/jellyfin:10.8.4";
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "Europe/Berlin";
            DOCKER_MODS = "linuxserver/mods:jellyfin-opencl-intel";
          };
          volumes = [
            "/data/jellyfin/library:/config"
            "/data/jellyfin/tvseries:/data/tvshows"
            "/data/jellyfin/movies:/data/movies"
          ];
          ports = [
            "8003:8096"
          ];
          extraOptions = [
            "--pull=always"
            "--device=/dev/dri:/dev/dri"
          ];
        };
        "librespeed" = {
          image = "lscr.io/linuxserver/librespeed:latest";
          environment = {
            TZ = "Europe/Berlin";
          };
          ports = [
            "8004:80"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "paperless" = {
          image = "lscr.io/linuxserver/paperless-ngx:latest";
          environment = {
            PUID = "1000";
           PGID = "100";
             TZ = "Europe/Berlin";
            PAPERLESS_URL = "https://paperless.baduhai.me";
            PAPERLESS_OCR_LANGUAGE = "eng+deu+por";
            DOCKER_MODS = "linuxserver/mods:papermerge-multilangocr";
          OCRLANG = "eng,por,deu";
          };
          volumes = [
            "/data/paperless-ngx/config:/config"
            "/data/paperless-ngx/data:/data"
          ];
          ports = [
            "8005:8000"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "pyload" = { # Download manager
          image = "lscr.io/linuxserver/pyload-ng:latest";
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "Europe/Berlin";
          };
          volumes = [
            "/data/pyload/config:/config"
            "/data/pyload/downloads:/downloads"
          ];
          ports = [
            "8006:8000"
            "9666:9666"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "shiori" = {
          image = "docker.io/nicholaswilde/shiori:latest";
          environment = {
            TZ = "Europe/Berlin";
            PUID = "1000";
            PGID = "100";
            SHIORI_DIR = "/data";
          };
          volumes = [
            "/data/shiori:/data"
          ];
          ports = [
            "8007:8080"
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
            "8008:8384"
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
            WHOOGLE_CONFIG_SEARCH_LANGUAGE = "lang_en";
            WHOOGLE_CONFIG_THEME = "system";
            WHOOGLE_CONFIG_VIEW_IMAGE = "1";
            WHOOGLE_CONFIG_GET_ONLY = "1";
          };
          ports = [
            "8009:5000"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
      };
    };
  };
}
