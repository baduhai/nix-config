{
  config,
  lib,
  inputs,
  ...
}:
let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
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
          DOMAIN = "git.baduhai.dev";
          ROOT_URL = "https://git.baduhai.dev";
          OFFLINE_MODE = true; # disable use of CDNs
          SSH_DOMAIN = "baduhai.dev";
        };
        log.LEVEL = "Warn";
        mailer.ENABLED = false;
        actions.ENABLED = false;
        service.DISABLE_REGISTRATION = true;
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          UPDATE_AVATAR = true;
          ACCOUNT_LINKING = "login";
          USERNAME = "preferred_username";
        };
      };
    };
    nginx.virtualHosts = mkNginxVHosts {
      domains."git.baduhai.dev".locations."/".proxyPass =
        "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:/";
    };
    fail2ban.jails.forgejo = {
      settings = {
        enabled = true;
        filter = "forgejo";
        logpath = "${config.services.forgejo.stateDir}/log/forgejo.log";
        maxretry = 10;
        findtime = "1h";
        bantime = "15m";
      };
    };
  };

  environment.etc."fail2ban/filter.d/forgejo.conf".text = ''
    [Definition]
    failregex = .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
    ignoreregex =
  '';
}
