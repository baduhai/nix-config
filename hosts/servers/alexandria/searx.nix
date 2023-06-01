{ inputs, config, pkgs, lib, ... }:

{
  services = {
    searx = {
      enable = true;
      package = pkgs.searxng;
      settings = { server.port = config.ports.searx; };
    };

    nginx.virtualHosts."searx.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.searx}";
    };
  };
}
