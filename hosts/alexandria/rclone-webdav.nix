{ config, pkgs, ... }:

let
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
  age.secrets.webdav = {
    file = ../../secrets/webdav.age;
    owner = "user";
    group = "users";
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
}
