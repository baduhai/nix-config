{ inputs, config, pkgs, lib, ... }:

{
  services = {
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://vaultwarden.baduhai.me";
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = "${config.ports.vaultwarden}";
      };
    };

    nginx.virtualHosts."vaultwarden.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.vaultwarden}";
    };
  };
}
