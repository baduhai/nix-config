{ inputs, config, pkgs, lib, ... }:

{
  services = {
    paperless = {
      enable = true;
      dataDir = "/data/paperless/data";
      mediaDir = "/data/paperless/media";
      passwordFile = config.age.secrets.paperless-pass.path;
      port = lib.toInt "${config.ports.paperless}";
      consumptionDirIsPublic = true;
      extraConfig = { PAPERLESS_OCR_LANGUAGE = "eng+por+deu"; };
    };

    nginx.virtualHosts."paperless.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.paperless}";
    };
  };

  age.secrets.paperless-pass = {
    file = ../../../secrets/paperless-pass.age;
    owner = "paperless";
    group = "hosted";
  };
}
