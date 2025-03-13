{
  config,
  pkgs,
  lib,
  ...
}:

{
  services = {
    searx = {
      enable = true;
      package = pkgs.searxng;
      settings.server = {
        port = lib.toInt "${config.ports.searx}";
        bind_address = "0.0.0.0";
        secret_key = "&yEf!xLA@y3FdJ5BjKnUnNAkqer$iW!9";
        method = "GET";
      };
    };

    nginx.virtualHosts."search.baduhai.dev" = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.searx}";
    };
  };
}
