{ config, lib, ... }:

{
  services = {
    paperless = {
      enable = true;
      dataDir = "/data/paperless/data";
      mediaDir = "/data/paperless/media";
      passwordFile = config.age.secrets.paperless.path;
      port = lib.toInt "${config.ports.paperless}";
      consumptionDirIsPublic = true;
      settings = {
        PAPERLESS_OCR_LANGUAGE = "eng+por+deu";
      };
    };

    nginx.virtualHosts."docs.baduhai.dev" = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.paperless}";
    };
  };

  age.secrets.paperless = {
    file = ../../../secrets/paperless.age;
    owner = "paperless";
    group = "hosted";
  };
}
