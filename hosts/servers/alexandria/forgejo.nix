{ config, ... }:

let
  domain = "git.baduhai.dev";
in

{
  services = {
    forgejo = {
      enable = true;
      settings = {
        session.COOKIE_SECURE = true;
        server = {
          PROTOCOL = "http+unix";
          DOMAIN = domain;
          SSH_DOMAIN = config.networking.domain;
          ROOT_URL = "https://${domain}";
          OFFLINE_MODE = true; # disable use of CDNs
        };
        log.LEVEL = "Warn";
        mailer.ENABLED = false;
        actions.ENABLED = false;
      };
    };
    nginx.virtualHosts.${domain} = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:/";
    };
  };
}
