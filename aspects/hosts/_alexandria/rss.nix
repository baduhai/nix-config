{ config, pkgs, inputs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
  fusionPkg = inputs.fusion.packages.${pkgs.system}.default;
in

{
  services = {
    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev".locations."/".proxyPass = "http://localhost:58000/";
    };
  };

  systemd.services.fusion = {
    description = "Fusion RSS Reader";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      FUSION_PORT = "58000";
      FUSION_DB_PATH = "/var/lib/fusion/fusion.db";
      FUSION_FEVER_USERNAME = "fusion";
      FUSION_PULL_INTERVAL = "1800";
      FUSION_PULL_TIMEOUT = "30";
      FUSION_PULL_CONCURRENCY = "10";
      FUSION_PULL_MAX_BACKOFF = "172800";
      FUSION_ALLOW_PRIVATE_FEEDS = "true";
      FUSION_ALLOW_EMPTY_PASSWORD = "true";
      FUSION_LOG_LEVEL = "INFO";
    };

    serviceConfig = {
      ExecStart = "${fusionPkg}/bin/fusion";
      DynamicUser = true;
      StateDirectory = "fusion";
      RuntimeDirectory = "fusion";
      Restart = "on-failure";
      RestartSec = 10;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      NoNewPrivileges = true;
      RestrictRealtime = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" ];
    };
  };

}
