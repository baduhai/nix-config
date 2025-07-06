{ config, lib, ... }:

let
  ports = {
    jellyfin = "8096";
    librespeed = "8000";
    radicale = "8001";
    vaultwarden = "8002";
    webdav = "8003";
  };
in

{
  services = {
    forgejo = {
      enable = true;
      repositoryRoot = "/data/forgejo";
      settings = {
        session.COOKIE_SECURE = true;
        server = {
          PROTOCOL = "http+unix";
          DOMAIN = "git.baduhai.dev";
          ROOT_URL = "https://git.baduhai.dev";
          OFFLINE_MODE = true; # disable use of CDNs
          SSH_DOMAIN = "baduhai.dev";
        };
        log.LEVEL = "Warn";
        mailer.ENABLED = false;
        actions.ENABLED = false;
      };
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts =
        let
          commonVHostConfig = {
            useACMEHost = "baduhai.dev";
            forceSSL = true;
            kTLS = true;
          };
        in
        lib.mapAttrs (_: lib.recursiveUpdate commonVHostConfig) {
          "_".locations."/".return = "444";
          "dav.baduhai.dev".locations."/" = {
            proxyPass = "http://127.0.0.1:${ports.radicale}";
            extraConfig = "proxy_pass_header Authorization;";
          };
          "git.baduhai.dev".locations."/".proxyPass =
            "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:/";
          "jellyfin.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.jellyfin}";
          "pass.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.vaultwarden}";
          "speedtest.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.librespeed}";
          # "webdav.baduhai.dev".locations."/" = {
          #   proxyPass = "http://127.0.0.1:${ports.webdav}";
          #   proxyNoTimeout = true;
          # };
        };
    };

    radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [
            "127.0.0.1:${ports.radicale}"
            "[::]:${ports.radicale}"
          ];
        };
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
      };
    };

    rclone-webdav = {
      enable = true;
      authFile = config.age.secrets.webdav.path;
      dataDirectory = "/data/webdav";
      maxFileSize = "5G";
      listenAddresses = [ "0.0.0.0" ];
      port = lib.toInt ports.webdav;
    };

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://pass.baduhai.dev";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = "${ports.vaultwarden}";
      };
    };
  };

  virtualisation.oci-containers.containers."librespeed" = {
    image = "lscr.io/linuxserver/librespeed:latest";
    environment = {
      TZ = "America/Bahia";
    };
    ports = [ "${ports.librespeed}:80" ];
    extraOptions = [
      "--pull=newer"
      "--label=io.containers.autoupdate=registry"
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "baduhai@proton.me";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare.path;
    };
    certs."baduhai.dev" = {
      extraDomainNames = [ "*.baduhai.dev" ];
    };
  };

  age.secrets = {
    cloudflare = {
      file = ../../../secrets/cloudflare.age;
      owner = "nginx";
      group = "nginx";
    };
    webdav = {
      file = ../../../secrets/webdav.age;
      owner = "webdav";
      group = "webdav";
    };
  };

  # TODO: remove when bug fix
  # serokell/deploy-rs/issues/57
  # NixOS/nixpkgs/issues/180175
  # Workaround for upstream bug in NetworkManager-wait-online.service
  systemd.services.NetworkManager-wait-online.enable = false;
}
