{
  config,
  lib,
  pkgs,
  ...
}:

let
  ports = {
    jellyfin = "8096";
    librespeed = "8000";
    radicale = "8001";
    vaultwarden = "8002";
  };
  rclone-webdav-start = pkgs.writeShellScript "rclone-webdav-start.sh" ''
    #!/bin/bash

    # Configuration
    CREDS_FILE="/run/agenix/webdav"
    SERVE_DIR="/data/webdav"
    SOCKET_PATH="/run/rclone-webdav/webdav.sock"

    # Check if credentials file exists
    if [ ! -f "$CREDS_FILE" ]; then
      echo "Error: Credentials file $CREDS_FILE not found"
      exit 1
    fi

    # Read credentials from file (format: username:password)
    CREDENTIALS=$(cat "$CREDS_FILE")
    USERNAME=$(echo "$CREDENTIALS" | cut -d':' -f1)
    PASSWORD=$(echo "$CREDENTIALS" | cut -d':' -f2)

    # Validate credentials
    if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
      echo "Error: Invalid credentials format. Expected username:password"
      exit 1
    fi

    # Ensure serve directory exists
    mkdir -p "$SERVE_DIR"

    # Remove existing socket if it exists
    rm -f "$SOCKET_PATH"

    # Start rclone serve webdav
    exec ${pkgs.rclone}/bin/rclone serve webdav "$SERVE_DIR" \
      --addr unix://"$SOCKET_PATH" \
      --user "$USERNAME" \
      --pass "$PASSWORD" \
      --verbose
  '';
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
      };
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts =
        let
          commonVHostConfig = {
            useACMEHost = "baduhai.dev";
            forceSSL = true;
            kTLS = true;
          };
        in
        lib.mapAttrs (_: lib.recursiveUpdate commonVHostConfig) {
          "_".locations."/".return = "444";
          "dav.baduhai.dev".locations."/" = {
            proxyPass = "http://127.0.0.1:${ports.radicale}";
            extraConfig = "proxy_pass_header Authorization;";
          };
          "git.baduhai.dev".locations."/".proxyPass =
            "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:/";
          "jellyfin.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.jellyfin}";
          "pass.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.vaultwarden}";
          "speedtest.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.librespeed}";
          # "webdav.baduhai.dev".locations."/" = {
          #   proxyPass = "http://127.0.0.1:${ports.webdav}";
          #   proxyNoTimeout = true;
          # };
        };
    };

    radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [
            "127.0.0.1:${ports.radicale}"
            "[::]:${ports.radicale}"
          ];
        };
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
      };
    };

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://pass.baduhai.dev";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = "${ports.vaultwarden}";
      };
    };
  };

  virtualisation.oci-containers.containers."librespeed" = {
    image = "lscr.io/linuxserver/librespeed:latest";
    environment = {
      TZ = "America/Bahia";
    };
    ports = [ "${ports.librespeed}:80" ];
    extraOptions = [
      "--pull=newer"
      "--label=io.containers.autoupdate=registry"
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "baduhai@proton.me";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare.path;
    };
    certs."baduhai.dev" = {
      extraDomainNames = [ "*.baduhai.dev" ];
    };
  };

  age.secrets = {
    cloudflare = {
      file = ../../../secrets/cloudflare.age;
      owner = "nginx";
      group = "nginx";
    };
    webdav = {
      file = ../../../secrets/webdav.age;
      owner = "webdav";
      group = "webdav";
    };
  };

  systemd.services = {
    # TODO: remove when bug fix
    # serokell/deploy-rs/issues/57
    # NixOS/nixpkgs/issues/180175
    # Workaround for upstream bug in NetworkManager-wait-online.service
    NetworkManager-wait-online.enable = false;
    rclone-webdav = {
      description = "RClone WebDAV Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "exec";
        User = "user";
        Group = "users";
        ExecStart = "${rclone-webdav-start}";
        Restart = "always";
        RestartSec = "10";

        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [
          "/data/webdav"
          "/run"
        ];

        # Create runtime directory for socket
        RuntimeDirectory = "rclone-webdav";
        RuntimeDirectoryMode = "0755";
      };

      # Ensure the user exists
      preStart = ''
        # Create webdav directory if it doesn't exist
        mkdir -p /data/webdav
        chown user:users /data/webdav
        chmod 755 /data/webdav
      '';
    };
  };
}
