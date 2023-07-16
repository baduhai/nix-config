{ inputs, config, pkgs, lib, ... }:

{
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      datadir = "/data/nextcloud";
      hostName = "nextcloud.baduhai.me";
      configureRedis = true;
      https = true;
      autoUpdateApps.enable = true;
      # notify_push.enable = true;
      secretFile = config.age.secrets.nextcloud-secrets.path;
      database.createLocally = true;
      caching = {
        apcu = true;
        redis = true;
      };
      config = {
        dbtype = "pgsql";
        defaultPhoneRegion = "BR";
        trustedProxies = [ "127.0.0.1" ];
        adminpassFile = config.age.secrets.nextcloud-adminpass.path;
      };
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
