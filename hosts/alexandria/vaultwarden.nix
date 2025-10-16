{
  config,
  lib,
  inputs,
  ...
}:
let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
in
{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://pass.baduhai.dev";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "/run/vaultwarden/vaultwarden.sock";
    };
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    acmeHost = "baduhai.dev";
    domains."pass.baduhai.dev".locations."/".proxyPass =
      "http://unix:${config.services.vaultwarden.config.ROCKET_ADDRESS}:/";
  };
}
