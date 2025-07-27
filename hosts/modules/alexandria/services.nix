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
      --config="" \
      --baseurl "/webdav" \
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
          "dav.baduhai.dev".locations = {
            "/caldav" = {
              proxyPass = "http://127.0.0.1:${ports.radicale}/";
              extraConfig = ''
                proxy_set_header X-Script-Name /caldav;
                proxy_pass_header Authorization;
              '';
            };
            "/webdav" = {
              proxyPass = "http://unix:/run/rclone-webdav/webdav.sock:/webdav/";
              extraConfig = ''
                proxy_set_header X-Script-Name /webdav;
                proxy_pass_header Authorization;
                proxy_connect_timeout 300; # Increase timeouts for large file uploads
                proxy_send_timeout 300;
                proxy_read_timeout 300;
                client_max_body_size 10G; # Allow large file uploads
                proxy_buffering off; # Buffer settings for better performance
                proxy_request_buffering off;
              '';
            };
          };
          "git.baduhai.dev".locations."/".proxyPass =
            "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:/";
          "jellyfin.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.jellyfin}/";
          "pass.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.vaultwarden}/";
          "speedtest.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${ports.librespeed}/";
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
      owner = "user";
      group = "users";
    };
  };

  systemd.services = {
    rclone-webdav = {
      description = "RClone WebDAV Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        User = "user";
        Group = "nginx";
        ExecStart = "${rclone-webdav-start}";
        Restart = "always";
        RestartSec = "10";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [
          "/data/webdav"
          "/run"
        ];
        RuntimeDirectory = "rclone-webdav";
        RuntimeDirectoryMode = "0750";
        UMask = "0002";
      };
      preStart = ''
        mkdir -p /data/webdav
        chown user:users /data/webdav
        chmod 755 /data/webdav
      '';
    };
  };
}
