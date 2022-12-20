{ config, pkgs, libs, ... }:

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
        "baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:8000/"; };
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
#         "traefik" = { # Reverse proxy
#           image = "docker.io/traefik:v2.8";
#           cmd = [
#             "--api"
#             "--providers.docker=true" # Enable the docker traefik provider
#             "--providers.docker.exposedbydefault=false"
#             "--api.dashboard=true" # Enable the Trafik dashboard
#             "--certificatesresolvers.letsencrypt.acme.dnschallenge=true" # Enable dns challenge
#             "--certificatesresolvers.letsencrypt.acme.email=baduhai@baduhai.me" # Dummy email
#             "--certificatesresolvers.letsencrypt.acme.storage=/letsencrypt/acme.json"
#             "--certificatesresolvers.letsencrypt.acme.dnschallenge.provider=cloudflare" # Cloudflare has my dns records
#             "--certificatesresolvers.letsencrypt.acme.dnschallenge.resolvers=100.100.100.100:53" # Use tailscale as dns resolver
#             "--entrypoints.web.address=:80" # Listen on port 80
#             "--entrypoints.web.http.redirections.entrypoint.to=websecure" # Redirect all http trafic to https
#             "--entrypoints.web.http.redirections.entrypoint.scheme=https" # Redirect all http trafic to https
#             "--entrypoints.websecure.address=:443" # Redirect all http trafic to https
#             "--entrypoints.websecure.http.tls=true" # Enable tls
#             "--entrypoints.websecure.http.tls.certResolver=letsencrypt" # Use letsencrypt for tls
#             "--entrypoints.websecure.http.tls.domains[0].main=baduhai.me" # tls for top-level domain
#             "--entrypoints.websecure.http.tls.domains[0].sans=*.baduhai.me" # tls for sub-domains
#             "--global.sendAnonymousUsage=false" # Stop traefik from reporting usage data
#             "--global.checkNewVersion=false" # Don't check for new versions
#           ];
#           environment = { # Transfer to secret environmentFiles once I have a proper secrets solution
#             CLOUDFLARE_EMAIL = "haiwilliam0@gmail.com";
#             CLOUDFLARE_DNS_API_TOKEN = "_zorlWkGYhCBrxn3g82pqOOiy9XULTdP2j7VoMVK";
#           };
#           volumes = [
#             "/var/run/docker.sock:/var/run/docker.sock:ro"
#             "/data/traefik/certs:/letsencrypt"
#           ];
#           ports = [
#             "80:80"
#             "443:443"
#           ];
#           extraOptions = [
#             "--pull=always"
#             "--label=traefik.enable=true"
#             "--label=traefik.http.routers.traefik.service=api@internal"
#             "--label=traefik.http.routers.traefik.entrypoints=websecure"
#             "--label=traefik.http.routers.traefik.tls.certresolver=letsencrypt"
#             "--label=traefik.http.routers.traefik.rule=Host(`traefik.baduhai.me`)"
#           ];
#         };
        "homarr" = { # Dashboard
          image = "ghcr.io/ajnart/homarr:latest";
          volumes = [
            "/data/homarr/configs:/app/data/configs"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
          ports = [
            "8000:7575"
          ];
          extraOptions = [
            "--pull=always"
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.homarr.entrypoints=websecure"
            "--label=traefik.http.routers.homarr.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.homarr.loadbalancer.server.port=7575"
            "--label=traefik.http.routers.homarr.rule=Host(`baduhai.me`)"
          ];
        };
        "changedetection" = { # Detect changes in webpages
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
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.detect.entrypoints=websecure"
            "--label=traefik.http.routers.detect.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.detect.loadbalancer.server.port=5000"
            "--label=traefik.http.routers.detect.rule=Host(`detect.baduhai.me`)"
          ];
        };
        "cinny" = { # Cinny matrix client
          image = "ghcr.io/cinnyapp/cinny:latest";
          ports = [
            "8002:80"
          ];
          extraOptions = [
            "--pull=always"
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.cinny.entrypoints=websecure"
            "--label=traefik.http.routers.cinny.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.cinny.loadbalancer.server.port=80"
            "--label=traefik.http.routers.cinny.rule=Host(`cinny.baduhai.me`)"
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
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.jellyfin.entrypoints=websecure"
            "--label=traefik.http.routers.jellyfin.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.jellyfin.loadbalancer.server.port=8096"
            "--label=traefik.http.routers.jellyfin.rule=Host(`jellyfin.baduhai.me`)"
          ];
        };
        "librespeed" = { # Speedtest
          image = "lscr.io/linuxserver/librespeed:latest";
          environment = {
            TZ = "Europe/Berlin";
          };
          ports = [
            "8004:80"
          ];
          extraOptions = [
            "--pull=always"
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.librespeed.entrypoints=websecure"
            "--label=traefik.http.routers.librespeed.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.librespeed.loadbalancer.server.port=80"
            "--label=traefik.http.routers.librespeed.rule=Host(`librespeed.baduhai.me`)"
          ];
        };
        "paperless" = { # Digital document manager
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
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.paperless.entrypoints=websecure"
            "--label=traefik.http.routers.paperless.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.paperless.loadbalancer.server.port=8000"
            "--label=traefik.http.routers.paperless.rule=Host(`paperless.baduhai.me`)"
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
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.pyload.entrypoints=websecure"
            "--label=traefik.http.routers.pyload.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.pyload.loadbalancer.server.port=8000"
            "--label=traefik.http.routers.pyload.rule=Host(`pyload.baduhai.me`)"
          ];
        };
        "shiori" = { # Bookmark manager
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
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.shiori.entrypoints=websecure"
            "--label=traefik.http.routers.shiori.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.shiori.loadbalancer.server.port=8080"
            "--label=traefik.http.routers.shiori.rule=Host(`shiori.baduhai.me`)"
          ];
        };
        "syncthing" = { # P2P file synchronisation
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
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.syncthing.entrypoints=websecure"
            "--label=traefik.http.routers.syncthing.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.syncthing.loadbalancer.server.port=8384"
            "--label=traefik.http.routers.syncthing.rule=Host(`sync.baduhai.me`)"
          ];
        };
        "whoogle" = { # Anonymised google search
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
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.whoogle.entrypoints=websecure"
            "--label=traefik.http.routers.whoogle.tls.certresolver=letsencrypt"
            "--label=traefik.http.services.whoogle.loadbalancer.server.port=5000"
            "--label=traefik.http.routers.whoogle.rule=Host(`whoogle.baduhai.me`)"
          ];
        };
      };
    };
  };
}
