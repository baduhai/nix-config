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
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 58222;
    };
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."pass.baduhai.dev".locations."/".proxyPass =
      "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}/";
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
    config.services.vaultwarden.config.ROCKET_PORT
  ];
}
