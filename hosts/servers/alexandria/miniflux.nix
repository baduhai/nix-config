{ inputs, config, pkgs, lib, ... }:

{
  services = {
    miniflux = {
      enable = true;
      config = {
        PORT = config.ports.miniflux;
        FETCH_YOUTUBE_WATCH_TIME = "true";
        BASE_URL = "https://miniflux.baduhai.me";
      };
      adminCredentialsFile = config.age.secrets.miniflux-pass.path;
    };

    nginx.virtualHosts."miniflux.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.miniflux}";
    };
  };

  age.secrets.miniflux-pass = {
    file = ../../../secrets/miniflux-pass.age;
    owner = "miniflux";
    group = "hosted";
  };
}
