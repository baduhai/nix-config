{
  lib,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;

  services = inputs.self.services;

  vaultwarden = lib.findFirst
    (s: s.name == "vaultwarden")
    (throw "vaultwarden service not found")
    services;
in

{
  security.acme.certs."pass.baduhai.dev" = {
    group = "nginx";
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."pass.baduhai.dev".locations."/".proxyPass =
      "http://${vaultwarden.tailscaleIP}:58222/";
  };
}
