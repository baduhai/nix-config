{ config, ... }:

{
  services = {
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://pass.baduhai.dev";
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = "${config.ports.vaultwarden}";
      };
    };

    nginx.virtualHosts."pass.baduhai.dev" = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.vaultwarden}";
    };
  };
}
