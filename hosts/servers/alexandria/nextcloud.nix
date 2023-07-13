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
      secretFile = config.age.secrets.nextcloud.path;
    };

    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
    };
  };

  age.secrets.nextcloud = {
    file = ../../../secrets/nextcloud.json.age;
    owner = "nextcloud";
    group = "hosted";
  };
}
