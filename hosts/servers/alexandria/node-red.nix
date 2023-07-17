{ inputs, config, pkgs, lib, ... }:

{
  services = {
    node-red = {
      enable = true;
      group = "hosted";
      userDir = "/data/node-red";
    };

    nginx.virtualHosts."node-red.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass =
        "http://127.0.0.1:${builtins.toString config.services.node-red.port}";
    };
  };
}
