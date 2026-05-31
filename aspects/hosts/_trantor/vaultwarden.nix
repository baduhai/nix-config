{
  config,
  lib,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://pass.baduhai.dev";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 58222;
      SSO_ENABLED = true;
      SSO_AUTHORITY = "https://auth.baduhai.dev";
      SSO_SCOPES = "email profile groups offline_access";
      SSO_PKCE = true;
      SSO_SIGNUPS_MATCH_EMAIL = true;
      SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION = true;
      SSO_ONLY = true;
    };
    environmentFile = config.age.secrets.vaultwarden-sso.path;
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."pass.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:58222/";
  };

  services.fail2ban.jails = {
    vaultwarden-web = {
      settings = {
        enabled = true;
        filter = "vaultwarden-web";
        banaction = "%(banaction_allports)s";
        maxretry = 3;
        findtime = "10m";
        bantime = "1h";
      };
    };
    vaultwarden-admin = {
      settings = {
        enabled = true;
        filter = "vaultwarden-admin";
        banaction = "%(banaction_allports)s";
        maxretry = 3;
        findtime = "10m";
        bantime = "1h";
      };
    };
  };

  environment.etc."fail2ban/filter.d/vaultwarden-web.conf".text = ''
    [INCLUDES]
    before = common.conf

    [Definition]
    failregex = ^.*Username or password is incorrect. Try again. IP: <HOST>. Username:.*$
    ignoreregex =
    journalmatch = _SYSTEMD_UNIT=vaultwarden.service
  '';

  environment.etc."fail2ban/filter.d/vaultwarden-admin.conf".text = ''
    [INCLUDES]
    before = common.conf

    [Definition]
    failregex = ^.*Invalid admin token. IP: <HOST>.*$
    ignoreregex =
    journalmatch = _SYSTEMD_UNIT=vaultwarden.service
  '';

  environment.persistence.main.directories = [
    {
      directory = "/var/lib/bitwarden_rs";
      user = "vaultwarden";
      group = "vaultwarden";
      mode = "0700";
    }
  ];

  systemd.services.vaultwarden.serviceConfig = {
    PrivateMounts = lib.mkForce false;
    ProtectSystem = lib.mkForce false;
  };

  age.secrets.vaultwarden-sso = {
    file = "${inputs.self}/secrets/vaultwarden-sso.env.age";
    owner = "vaultwarden";
    group = "vaultwarden";
  };
}
