{ inputs, config, pkgs, libs, ... }:

{
  age.secrets = {
    paperless-pass = {
      file = ../../../secrets/paperless-pass.age;
      owner = "paperless";
      group = "hosted";
    };
  };

  services = {
    nginx = {
      enable = true;
      group = "hosted";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; root = inputs.homepage; };
        "cinny.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8002"; };
        "librespeed.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8003"; };
        "sync.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8006"; };
        "whoogle.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8007"; };
      };
    };

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://bitwarden.baduhai.me";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8000;
      };
    };
    nginx.virtualHosts."bitwarden.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };

    changedetection-io = {
      enable = true;
      group = "hosted";
      behindProxy = true;
      datastorePath = "/data/changedetection";
      port = 8001;
      baseURL = "https://detect.baduhai.me";
    };
    nginx.virtualHosts."detect.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${toString config.services.changedetection-io.port}";
    };

    jellyfin = {
      enable = true;
      group = "hosted";
    };
    nginx.virtualHosts."jellyfin.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:8096";
    };

    paperless = {
      enable = true;
      dataDir = "/data/paperless/data";
      mediaDir = "/data/paperless/media";
      passwordFile = config.age.secrets.paperless-pass.path;
      port = 8004;
      consumptionDirIsPublic = true;
      extraConfig = {
        PAPERLESS_OCR_LANGUAGE = "eng+por+deu";
      };
    };
    nginx.virtualHosts."paperless.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
    };

    shiori = {
      enable = true;
      port = 8005;
    };
    nginx.virtualHosts."shiori.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${toString config.services.shiori.port}";
    };

    radarr = {
      enable = true;
      group = "hosted";
    };
    nginx.virtualHosts."radarr.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:7878";
    };

    sonarr = {
      enable = true;
      group = "hosted";
    };
    nginx.virtualHosts."sonarr.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:8989";
    };

    bazarr = {
      enable = true;
      group = "hosted";
    };
    nginx.virtualHosts."bazarr.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:6767";
    };

    prowlarr.enable = true;
    nginx.virtualHosts."prowlarr.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:9696";
    };

    deluge = {
      enable = true;
      web.enable = true;
      group = "hosted";
      openFirewall = true;
    };
    nginx.virtualHosts."deluge.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:8112";
    };

    n8n.enable = true;
    nginx.virtualHosts."n8n.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:5678";
    };

    minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;
      openFirewall = true;
      package = pkgs.papermc;
      serverProperties = {
        motd = "Bem-vindo a Alexandria";
        difficulty = "hard";
        gamemode = "survival";
      };
      dataDir = "/data/minecraft";
    };
  };

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
            WHOOGLE_CONFIG_SEARCH_LANGUAGE = "lang_en";
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
