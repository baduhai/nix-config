{ lib, inputs, ... }:
let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;

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
    nginx.virtualHosts = mkNginxVHosts {
      acmeHost = "baduhai.dev";
      domains."dav.baduhai.dev".locations = {
        "/caldav" = {
          proxyPass = "http://unix:/run/radicale/radicale.sock:/";
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
            proxy_connect_timeout 300;
            proxy_send_timeout 300;
            proxy_read_timeout 300;
            client_max_body_size 10G;
            proxy_buffering off;
            proxy_request_buffering off;
          '';
        };
      };
    };
    radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [ "/run/radicale/radicale.sock" ];
        };
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
      };
    };
  };

  systemd.services.rclone-webdav = {
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

  age.secrets.webdav = {
    file = ../../secrets/webdav.age;
    owner = "user";
    group = "users";
  };
}
