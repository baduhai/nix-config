{ lib, inputs, ... }:
let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."jellyfin.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:8096/";
  };
}
