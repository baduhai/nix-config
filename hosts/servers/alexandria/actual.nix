{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."actual" = {
    image = "docker.io/jlongster/actual-server:latest";
    ports = [ "${config.ports.actual}:5006" ];
    volumes = [ "/data/actual:/data" ];
    extraOptions = [ "--label=io.containers.autoupdate=registry" ];
  };

  services.nginx.virtualHosts."actual.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.actual}";
  };
}
