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
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://bitwarden.baduhai.me";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = "${config.ports.vaultwarden}";
      };
    };

    changedetection-io = {
      enable = true;
      group = "hosted";
      behindProxy = true;
      datastorePath = "/data/changedetection";
      port = "${config.ports.changedetection-io}";
      baseURL = "https://detect.baduhai.me";
    };

    paperless = {
      enable = true;
      dataDir = "/data/paperless/data";
      mediaDir = "/data/paperless/media";
      passwordFile = config.age.secrets.paperless-pass.path;
      port = "${config.ports.paperless}";
      consumptionDirIsPublic = true;
      extraConfig = {
        PAPERLESS_OCR_LANGUAGE = "eng+por+deu";
      };
    };

    shiori = {
      enable = true;
      port = "${config.ports.shiori}";
    };

    n8n.enable = true;
  };
}
