{ config, pkgs, ... }:

{
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      datadir = "/data/nextcloud";
      hostName = "nextcloud.baduhai.dev";
      configureRedis = true;
      https = true;
      autoUpdateApps.enable = true;
      secretFile = config.age.secrets."nextcloud-secrets.json".path;
      database.createLocally = true;
      maxUploadSize = "16G";
      caching = {
        apcu = true;
        redis = true;
      };
      settings = {
        trusted_proxies = [ "127.0.0.1" ];
        default_phone_region = "BR";
        maintenance_window_start = "4";
      };
      config = {
        dbtype = "pgsql";
        adminpassFile = config.age.secrets.nextcloud-adminpass.path;
      };
      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
      };
    };

    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
    };
  };

  age.secrets = {
    "nextcloud-secrets.json" = {
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
