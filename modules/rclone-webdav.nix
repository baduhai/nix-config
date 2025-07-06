{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.rclone-webdav;

  parseUserFile =
    userFile:
    let
      content = builtins.readFile userFile;
      lines = filter (line: line != "" && !hasPrefix "#" line) (splitString "\n" content);
      parseUser =
        line:
        let
          parts = splitString ":" line;
        in
        {
          username = elemAt parts 0;
          password = elemAt parts 1;
        };
    in
    map parseUser lines;

  users = if cfg.authFile != null then parseUserFile cfg.authFile else [ ];
  usernames = map (u: u.username) users;

  socketDirectory = "/var/lib/webdav";

  # Generate rclone service for each user
  mkRcloneService =
    user:
    nameValuePair "rclone-webdav-${user.username}" {
      description = "rclone WebDAV service for ${user.username}";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "5s";

        # Ensure directories exist
        ExecStartPre = [
          "${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDirectory}/${user.username}"
          "${pkgs.coreutils}/bin/mkdir -p ${socketDirectory}"
          "${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} ${cfg.dataDirectory}/${user.username}"
          "${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} ${socketDirectory}"
        ];

        ExecStart = ''
          ${pkgs.rclone}/bin/rclone serve webdav ${cfg.dataDirectory}/${user.username} \
            --addr unix:${socketDirectory}/rclone-${user.username}.sock \
            --user ${user.username} \
            --pass ${user.password} \
            --log-level INFO
        '';

        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [
          cfg.dataDirectory
          socketDirectory
        ];
      };
    };

  # Generate nginx upstream for each user
  mkNginxUpstream = user: {
    name = "rclone-${user.username}";
    value = {
      servers = {
        "unix:${socketDirectory}/rclone-${user.username}.sock" = { };
      };
    };
  };

  # Generate nginx location for each user
  mkNginxLocation = user: {
    name = "/${user.username}/";
    value = {
      proxyPass = "http://rclone-${user.username}";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Remove the username prefix from the path
        rewrite ^/${user.username}/(.*) /$1 break;

        # WebDAV specific headers
        proxy_set_header Destination $http_destination;
        proxy_set_header Depth $http_depth;
        proxy_set_header Overwrite $http_overwrite;
        proxy_set_header Lock-Token $http_lock_token;
        proxy_set_header If $http_if;

        # Allow WebDAV methods
        proxy_method $request_method;

        # Increase timeouts for large file uploads
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;

        # Set maximum file size for this location
        client_max_body_size ${cfg.maxFileSize};
      '';
    };
  };

in
{
  options.services.rclone-webdav = {
    enable = mkEnableOption "rclone WebDAV multi-user service";

    authFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to file containing username:password pairs, one per line";
      example = "/etc/rclone-webdav-users";
    };

    dataDirectory = mkOption {
      type = types.str;
      default = "/srv/webdav";
      description = "Base directory where user subdirectories will be created";
    };

    user = mkOption {
      type = types.str;
      default = "webdav";
      description = "User to run rclone services as";
    };

    group = mkOption {
      type = types.str;
      default = "webdav";
      description = "Group to run rclone services as";
    };

    listenAddresses = mkOption {
      type = types.listOf types.str;
      default = [ "localhost" ];
      description = "List of addresses for nginx to listen on";
      example = [
        "localhost"
        "127.0.0.1"
        "::1"
      ];
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "Port for nginx to listen on";
    };

    maxFileSize = mkOption {
      type = types.str;
      default = "0";
      description = "Maximum file size for uploads (nginx client_max_body_size). Use '0' for unlimited.";
      example = "100M";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.authFile != null;
        message = "services.rclone-webdav.authFile must be specified";
      }
      {
        assertion = users != [ ];
        message = "Auth file must contain at least one user";
      }
    ];

    # Create user and group
    users.users = mkIf (cfg.user == "webdav") {
      webdav = {
        isSystemUser = true;
        group = cfg.group;
        description = "rclone WebDAV service user";
        home = cfg.dataDirectory;
        createHome = true;
      };
    };

    users.groups = mkIf (cfg.group == "webdav") {
      webdav = {
        gid = null;
      };
    };

    # Create systemd services for each user
    systemd.services = listToAttrs (map mkRcloneService users);

    # Configure nginx
    services.nginx = {
      enable = true;

      upstreams = listToAttrs (map mkNginxUpstream users);

      virtualHosts."rclone-webdav" = {
        listen = map (addr: {
          addr = addr;
          port = cfg.port;
        }) cfg.listenAddresses;

        locations = listToAttrs (map mkNginxLocation users) // {
          "/" = {
            return = "200 'rclone WebDAV Multi-user Server'";
            extraConfig = ''
              add_header Content-Type text/plain;
            '';
          };

          # Catch-all location for non-existent users - return 400
          "~* ^/([^/]+)/" = {
            extraConfig = ''
              # Check if the requested user exists
              set $user_exists 0;
              ${concatStringsSep "\n" (
                map (username: "if ($1 = \"${username}\") { set $user_exists 1; }") usernames
              )}

              # If user doesn't exist, return 400
              if ($user_exists = 0) {
                return 400 "User not found";
              }

              # This should not be reached for valid users
              return 404;
            '';
          };
        };

        extraConfig = ''
          # Enable WebDAV methods
          dav_methods PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND PROPPATCH LOCK UNLOCK;

          # Set default maximum file size
          client_max_body_size ${cfg.maxFileSize};
        '';
      };
    };

    # Ensure directories exist
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDirectory} 0755 ${cfg.user} ${cfg.group} -"
      "d ${socketDirectory} 0755 ${cfg.user} ${cfg.group} -"
    ] ++ map (user: "d ${cfg.dataDirectory}/${user.username} 0755 ${cfg.user} ${cfg.group} -") users;
  };
}
