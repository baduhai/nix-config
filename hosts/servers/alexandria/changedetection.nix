{ config, lib, ... }:

{
  services = {
    changedetection-io = {
      enable = true;
      behindProxy = true;
      datastorePath = "/data/changedetection";
      port = lib.toInt "${config.ports.changedetection-io}";
      baseURL = "https://detect.baduhai.dev";
    };

    nginx.virtualHosts."detect.baduhai.dev" = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.changedetection-io}";
    };
  };
}
