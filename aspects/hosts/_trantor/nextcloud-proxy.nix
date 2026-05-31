{
  lib,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;

  services = inputs.self.services;

  svc = lib.findFirst
    (s: s.name == "nextcloud")
    (throw "nextcloud not found in services")
    services;
in

{
  security.acme.certs."cloud.baduhai.dev" = {
    group = "nginx";
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."cloud.baduhai.dev" = {
      locations."/".proxyPass = "https://${svc.tailscaleIP}/";
      locations."/".extraConfig = ''
        proxy_ssl_server_name on;
        proxy_ssl_verify off;
      '';
    };
  };
}
