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
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://bitwarden.baduhai.me";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8000;
      };
    };

    changedetection-io = {
      enable = true;
      group = "hosted";
      behindProxy = true;
      datastorePath = "/data/changedetection";
      port = 8001;
      baseURL = "https://detect.baduhai.me";
    };

    jellyfin = {
      enable = true;
      group = "hosted";
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

    shiori = {
      enable = true;
      port = 8005;
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

    n8n.enable = true;

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
}
