{ inputs, config, pkgs, lib, ... }:

{
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      hostName = "nextcloud.baduhai.me";
      configureRedis = true;
      caching.apcu = false;
      https = true;
      autoUpdateApps.enable = true;
      config.adminpassFile = config.age.secrets.nextcloud-adminpass.path;
      secretFile = config.age.secrets.nextcloud-secrets.path;
    };

    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
    };
  };

  age.secrets = {
    nextcloud-secrets = {
      file = ../../../secrets/nextcloud-secrets.json.age;
      owner = "nextcloud";
      group = "hosted";
    };
    nextcloud-adminpass = {
      file = ../../../secrets/nextcloud-adminpass.age;
      owner = "nextcloud";
      group = "hosted";
    };
  };
}
