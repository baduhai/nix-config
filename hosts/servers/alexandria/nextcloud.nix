{ inputs, config, pkgs, lib, ... }:

{
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      datadir = "/data/nextcloud";
      hostName = "nextcloud.baduhai.dev";
      configureRedis = true;
      https = true;
      autoUpdateApps.enable = true;
      secretFile = config.age.secrets."nextcloud-secrets.json".path;
      database.createLocally = true;
      maxUploadSize = "8G";
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
      phpOptions = {
        upload_max_filesize = lib.mkDefault "8G";
        post_max_size = lib.mkDefault "8G";
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
