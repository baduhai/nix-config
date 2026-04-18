{ inputs, pkgs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
  opencodePort = 58801;
  opencodePackage = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
in

{
  services.nginx.virtualHosts = mkNginxVHosts {
    domains = {
      "ai.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${toString opencodePort}/";
    };
  };

  systemd.services.opencode-web = {
    description = "OpenCode Web UI";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      StateDirectory = "opencode-web";
      WorkingDirectory = "/var/lib/opencode-web";
      Environment = "HOME=/var/lib/opencode-web";
      ExecStart = "${opencodePackage}/bin/opencode web --hostname 127.0.0.1 --port ${toString opencodePort}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
