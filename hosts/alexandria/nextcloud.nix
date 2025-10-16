{
  lib,
  config,
  pkgs,
  ...
}:

{
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      datadir = "/data/nextcloud";
      hostName = "cloud.baduhai.dev";
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
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\EMF"
          "OC\\Preview\\Font"
          "OC\\Preview\\GIF"
          "OC\\Preview\\HEIC"
          "OC\\Preview\\Illustrator"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\Movie"
          "OC\\Preview\\MP3"
          "OC\\Preview\\MSOffice2003"
          "OC\\Preview\\MSOffice2007"
          "OC\\Preview\\MSOfficeDoc"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PDF"
          "OC\\Preview\\Photoshop"
          "OC\\Preview\\PNG"
          "OC\\Preview\\Postscript"
          "OC\\Preview\\SVG"
          "OC\\Preview\\TIFF"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
        ];
      };
      config = {
        dbtype = "pgsql";
        adminpassFile = config.age.secrets.nextcloud-adminpass.path;
      };
      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
      };
    };

    collabora-online = {
      enable = true;
      settings = {
        ssl = {
          enable = false;
          termination = true;
        };
        net = {
          listen = "unix";
          frame_ancestors = "cloud.baduhai.dev";
        };
      };
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
