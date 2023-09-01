{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."logseq" = {
    image = "ghcr.io/logseq/logseq-webapp:latest";
    ports = [ "${config.ports.logseq}:80" ];
    environment = { TZ = "America/Bahia"; };
    extraOptions = [ "--label=io.containers.autoupdate=registry" ];
  };

  services.nginx.virtualHosts."logseq.baduhai.dev" = {
    useACMEHost = "baduhai.dev";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.logseq}";
  };
}
