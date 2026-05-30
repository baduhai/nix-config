{
  config,
  lib,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;

  services = inputs.self.services;

  laterfeed = lib.findFirst
    (s: s.name == "laterfeed")
    (throw "laterfeed service not found")
    services;
in

{
  security.acme.certs."read.baduhai.dev" = {
    group = "nginx";
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."read.baduhai.dev" = {
      locations."/".proxyPass = "http://${laterfeed.tailscaleIP}:58001/";
      extraConfig = ''
        ssl_client_certificate ${config.age.secrets."mtls-ca-crt".path};
        ssl_verify_client on;
      '';
    };
  };

  age.secrets."mtls-ca-crt" = {
    file = "${inputs.self}/secrets/mtls-ca.crt.age";
    owner = "nginx";
    group = "nginx";
  };
}
