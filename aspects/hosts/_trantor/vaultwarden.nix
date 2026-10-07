{
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
  mkContainer = inputs.self.lib.mkContainer;
in

{
  services.nginx.virtualHosts = mkNginxVHosts {
    domains."pass.baduhai.dev".locations."/".proxyPass = "http://10.233.1.2:58222/";
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
        logpath = "/var/log/containers/vaultwarden/vaultwarden.log";
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
        logpath = "/var/log/containers/vaultwarden/vaultwarden.log";
      };
    };
  };

  environment.etc."fail2ban/filter.d/vaultwarden-web.conf".text = ''
    [INCLUDES]
    before = common.conf

    [Definition]
    failregex = ^.*Username or password is incorrect. Try again. IP: <HOST>. Username:.*$
    ignoreregex =
  '';

  environment.etc."fail2ban/filter.d/vaultwarden-admin.conf".text = ''
    [INCLUDES]
    before = common.conf

    [Definition]
    failregex = ^.*Invalid admin token. IP: <HOST>.*$
    ignoreregex =
  '';

  # Container writes its log here so host fail2ban can read it.
  systemd.tmpfiles.rules = [
    "d /var/log/containers/vaultwarden 0750 vaultwarden vaultwarden - -"
  ];

  age.secrets.vaultwarden-sso = {
    file = "${inputs.self}/secrets/vaultwarden-sso.env.age";
    owner = "vaultwarden";
    group = "vaultwarden";
  };

  # The host still owns the decrypted secret and the shared log dir, so the
  # service user must exist here too (pinned to the container's uid/gid).
  users = {
    users.vaultwarden = {
      isSystemUser = true;
      group = "vaultwarden";
      uid = 991;
    };
    groups.vaultwarden.gid = 989;
  };

  containers.vaultwarden = mkContainer {
    index = 1;
    bindMounts."/var/log/containers/vaultwarden" = {
      hostPath = "/var/log/containers/vaultwarden";
      isReadOnly = false;
    };
    config = { ... }: {
      # uid/gid pinned to the host's existing on-disk ownership so the moved
      # data keeps its owner without a recursive chown.
      users = {
        users.vaultwarden.uid = 991;
        groups.vaultwarden.gid = 989;
      };
      # ProtectSystem=strict would otherwise make the log dir read-only.
      systemd.services.vaultwarden.serviceConfig.ReadWritePaths = [
        "/var/log/containers/vaultwarden"
      ];
      services.vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://pass.baduhai.dev";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "0.0.0.0";
          ROCKET_PORT = 58222;
          LOG_FILE = "/var/log/containers/vaultwarden/vaultwarden.log";
          SSO_ENABLED = true;
          SSO_AUTHORITY = "https://auth.baduhai.dev";
          SSO_SCOPES = "email profile groups offline_access";
          SSO_PKCE = true;
          SSO_SIGNUPS_MATCH_EMAIL = true;
          SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION = true;
        };
        environmentFile = "/run/agenix/vaultwarden-sso";
      };
    };
  };
}
