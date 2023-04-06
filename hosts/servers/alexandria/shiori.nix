{ inputs, config, pkgs, lib, ... }:

{
  services = {
    shiori = {
      enable = true;
      port = lib.toInt "${config.ports.shiori}";
    };

    nginx.virtualHosts."shiori.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.shiori}";
    };
  };
}
