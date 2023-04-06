{ inputs, config, pkgs, lib, ... }:

{
  services = {
    changedetection-io = {
      enable = true;
      group = "hosted";
      behindProxy = true;
      datastorePath = "/data/changedetection";
      port = lib.toInt "${config.ports.changedetection-io}";
      baseURL = "https://detect.baduhai.me";
    };

    nginx.virtualHosts."detect.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass =
        "http://127.0.0.1:${config.ports.changedetection-io}";
    };
  };
}
