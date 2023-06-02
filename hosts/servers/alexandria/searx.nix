{ inputs, config, pkgs, lib, ... }:

{
  services = {
    searx = {
      enable = true;
      settings = {
        server.port = config.ports.searx;
        server.secret_key = "SEARX_SECRET_KEY";
      };
    };

    nginx.virtualHosts."searx.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.searx}";
    };
  };
}
