{
  config,
  lib,
  inputs,
  ...
}:

let
  utils = import ../../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
in

{
  services = {
    forgejo = {
      enable = true;
      settings = {
        session.COOKIE_SECURE = true;
        server = {
          PROTOCOL = "http+unix";
          DOMAIN = "git.baduhai.dev";
          ROOT_URL = "https://git.baduhai.dev";
          OFFLINE_MODE = true; # disable use of CDNs
          SSH_DOMAIN = "git.baduhai.dev";
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
        maxretry = 3;
        findtime = "10m";
        bantime = "1h";
      };
    };
  };

  environment = {
    etc."fail2ban/filter.d/forgejo.conf".text = ''
      [Definition]
      failregex = .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=forgejo.service
    '';

    persistence.main.directories = [
      {
        directory = config.services.forgejo.stateDir;
        inherit (config.services.forgejo) user group;
        mode = "0700";
      }
    ];
  };

  # Disable PrivateMounts to allow LoadCredential to work with bind-mounted directories
  systemd.services.forgejo.serviceConfig.PrivateMounts = lib.mkForce false;
}
