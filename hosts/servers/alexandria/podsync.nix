{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."podsync" = {
    image = "docker.io/mxpv/podsync:latest";
    environment = { TZ = "America/Bahia"; };
    ports = [ "${config.ports.podsync}:80" ];
    volumes = [ "${config.age.secrets."podsync.toml".path}:/app/config.toml" ];
    extraOptions = [ "--label=io.containers.autoupdate=registry" ];
  };

  services.nginx.virtualHosts."podsync.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.podsync}";
  };

  age.secrets."podsync.toml".file = ../../../secrets/podsync.toml.age;
}
