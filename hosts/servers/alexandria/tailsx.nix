{ inputs, config, pkgs, lib, ... }:

{
  services.nginx.virtualHosts."search.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.searx}";
  };
}
