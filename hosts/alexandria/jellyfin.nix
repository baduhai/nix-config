{ lib, inputs, ... }:
let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    acmeHost = "baduhai.dev";
    domains."jellyfin.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:8096/";
  };
}
