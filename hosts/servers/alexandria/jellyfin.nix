{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  services = {
    jellyfin = {
      enable = true;
      user = "user";
      group = "hosted";
      openFirewall = true;
    };

    nginx.virtualHosts."jellyfin.baduhai.dev" = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.jellyfin}";
    };
  };
}
