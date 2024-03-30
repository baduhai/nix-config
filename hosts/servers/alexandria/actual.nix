{ config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."actual" = {
    image = "docker.io/actualbudget/actual-server:latest";
    ports = [ "${config.ports.actual}:5006" ];
    volumes = [ "/data/actual:/data" ];
    extraOptions = [ "--pull=newer --label=io.containers.autoupdate=registry" ];
  };

  services.nginx.virtualHosts."actual.baduhai.dev" = {
    useACMEHost = "baduhai.dev";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.actual}";
  };
}
