{ config, ... }:

let
  domain = "git.baduhai.dev";
in

{
  services = {
    forgejo = {
      enable = true;
      repositoryRoot = "/data/forgejo";
      settings = {
        session.COOKIE_SECURE = true;
        server = {
          PROTOCOL = "http+unix";
          DOMAIN = domain;
          ROOT_URL = "https://${domain}";
          OFFLINE_MODE = true; # disable use of CDNs
          SSH_DOMAIN = "baduhai.dev";
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
