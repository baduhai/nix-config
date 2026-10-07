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
    domains."git.baduhai.dev".locations."/".proxyPass = "http://10.233.2.2:3000/";
  };

  services.fail2ban.jails.forgejo = {
    settings = {
      enabled = true;
      filter = "forgejo";
      maxretry = 3;
      findtime = "10m";
      bantime = "1h";
      logpath = "/var/log/containers/forgejo/gitea.log";
    };
  };

  environment.etc."fail2ban/filter.d/forgejo.conf".text = ''
    [Definition]
    failregex = .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
    ignoreregex =
  '';

  # Container writes its log here so host fail2ban can read it.
  systemd.tmpfiles.rules = [
    "d /var/log/containers/forgejo 0750 forgejo forgejo - -"
  ];

  # The host owns the shared log dir, so the service user must exist here too
  # (pinned to the container's uid/gid).
  users = {
    users.forgejo = {
      isSystemUser = true;
      group = "forgejo";
      uid = 997;
    };
    groups.forgejo.gid = 997;
  };

  containers.forgejo = mkContainer {
    index = 2;
    bindMounts."/var/log/containers/forgejo" = {
      hostPath = "/var/log/containers/forgejo";
      isReadOnly = false;
    };
    config = { ... }: {
      # uid/gid pinned to the host's existing on-disk ownership so the moved
      # data keeps its owner without a recursive chown.
      users = {
        users.forgejo.uid = 997;
        groups.forgejo.gid = 997;
      };
      # ProtectSystem=strict would otherwise make the log dir read-only.
      systemd.services.forgejo.serviceConfig.ReadWritePaths = [
        "/var/log/containers/forgejo"
      ];
      services.forgejo = {
        enable = true;
        settings = {
          session.COOKIE_SECURE = true;
          server = {
            PROTOCOL = "http";
            HTTP_ADDR = "0.0.0.0";
            HTTP_PORT = 3000;
            DOMAIN = "git.baduhai.dev";
            ROOT_URL = "https://git.baduhai.dev";
            OFFLINE_MODE = true; # disable use of CDNs
            DISABLE_SSH = true; # git-over-SSH is not supported in a container
          };
          log = {
            LEVEL = "Warn";
            MODE = "file";
            ROOT_PATH = "/var/log/containers/forgejo";
          };
          mailer.ENABLED = false;
          actions.ENABLED = true;
          service.DISABLE_REGISTRATION = true;
          service.ENABLE_INTERNAL_SIGNIN = false;
          oauth2_client = {
            ENABLE_AUTO_REGISTRATION = true;
            UPDATE_AVATAR = true;
            ACCOUNT_LINKING = "login";
            USERNAME = "preferred_username";
          };
        };
      };
    };
  };
}
