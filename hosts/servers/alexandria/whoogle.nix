{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."whoogle" = {
    image = "benbusby/whoogle-search:latest";
    environment = {
      HTTPS_ONLY = "1";
      WHOOGLE_CONFIG_LANGUAGE = "lang_en";
      WHOOGLE_CONFIG_THEME = "system";
      WHOOGLE_CONFIG_VIEW_IMAGE = "1";
      WHOOGLE_CONFIG_GET_ONLY = "1";
    };
    ports = [ "${config.ports.whoogle}:5000" ];
    extraOptions = [ "--pull=always" ];
  };

  services.nginx.virtualHosts."whoogle.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.whoogle}";
  };
}
