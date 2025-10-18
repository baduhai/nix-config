{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
in

{
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
      datadir = "/data/nextcloud";
      hostName = "cloud.baduhai.dev";
      configureRedis = true;
      https = true;
      secretFile = config.age.secrets."nextcloud-secrets.json".path;
      database.createLocally = true;
      maxUploadSize = "16G";
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) calendar contacts notes;
      };
      extraAppsEnable = true;
      appstoreEnable = true;
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

    nginx.virtualHosts = mkNginxVHosts {
      acmeHost = "baduhai.dev";
      domains."cloud.baduhai.dev" = { };
    };
  };

  age.secrets = {
    "nextcloud-secrets.json" = {
      file = ../../secrets/nextcloud-secrets.json.age;
      owner = "nextcloud";
      group = "nextcloud";
    };
    nextcloud-adminpass = {
      file = ../../secrets/nextcloud-adminpass.age;
      owner = "nextcloud";
      group = "nextcloud";
    };
  };
}
