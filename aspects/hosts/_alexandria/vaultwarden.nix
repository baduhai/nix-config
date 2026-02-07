{
  config,
  lib,
  inputs,
  ...
}:
let
  utils = import ../../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
in
{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://pass.baduhai.dev";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 58222;
    };
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."pass.baduhai.dev".locations."/".proxyPass =
      "http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}/";
  };
}
