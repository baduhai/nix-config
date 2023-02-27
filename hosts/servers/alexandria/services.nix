{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  age.secrets = {
    paperless-pass = {
      file = ../../../secrets/paperless-pass.age;
      owner = "paperless";
      group = "hosted";
    };
  };

  services = {
    bazarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    changedetection-io = {
      enable = true;
      group = "hosted";
      behindProxy = true;
      datastorePath = "/data/changedetection";
      port = lib.toInt "${config.ports.changedetection-io}";
      baseURL = "https://detect.baduhai.me";
    };

    invoiceplane.sites,"invoice.baduhai.me" = {
      enable = true;
      port = lib.toInt "${config.ports.paperless}";
      stateDir = "/data/invoiceplane";
      extraConfig = ''
        IP_URL=https://invoice.baduhai.me
      '';
    };

    jackett.enable = true;

    jellyfin = {
      enable = true;
      user = "user";
      group = "hosted";
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
        online-mode = "false";
        spawn-protection = "0";
      };
      dataDir = "/data/minecraft";
    };

    nginx = {
      enable = true;
      group = "hosted";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "baduhai.me" = {
          useACMEHost = "baduhai.me";
          forceSSL = true;
          kTLS = true;
          root = inputs.homepage;
        };
        "bazarr.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.bazaar}"; };
        "bitwarden.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.vaultwarden}"; };
        "cinny.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.cinny}"; };
        "detect.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.changedetection-io}"; };
        "invoice.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.invoiceplane}"; };
        "jackett.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.jackett}"; };
        "jellyfin.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.jellyfin}"; };
        "librespeed.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.librespeed}"; };
        "n8n.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.n8n}"; };
        "paperless.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.paperless}"; };
        "qbittorrent.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.qbittorrent}"; };
        "radarr.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.radarr}"; };
        "shiori.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.shiori}"; };
        "sonarr.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.sonarr}"; };
        "sync.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.syncthing}"; };
        "whoogle.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.whoogle}"; };
      };
    };

    paperless = {
      enable = true;
      dataDir = "/data/paperless/data";
      mediaDir = "/data/paperless/media";
      passwordFile = config.age.secrets.paperless-pass.path;
      port = lib.toInt "${config.ports.paperless}";
      consumptionDirIsPublic = true;
      extraConfig = {
        PAPERLESS_OCR_LANGUAGE = "eng+por+deu";
      };
    };

    postgresql.enable = true;

    qbittorrent = {
      enable = true;
      user = "user";
      group = "hosted";
      port = lib.toInt "${config.ports.qbittorrent}";
    };

    radarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    shiori = {
      enable = true;
      port = lib.toInt "${config.ports.shiori}";
    };

    sonarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://bitwarden.baduhai.me";
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = "${config.ports.vaultwarden}";
      };
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false; # Workaround for upstream bug in NetworkManager-wait-online.service
}
