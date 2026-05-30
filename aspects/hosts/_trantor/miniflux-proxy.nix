{
  lib,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;

  services = inputs.self.services;

  miniflux = lib.findFirst
    (s: s.name == "miniflux")
    (throw "miniflux service not found")
    services;
in

{
  security.acme.certs."rss.baduhai.dev" = {
    group = "nginx";
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."rss.baduhai.dev".locations."/".proxyPass =
      "http://${miniflux.tailscaleIP}:58000/";
  };
}
