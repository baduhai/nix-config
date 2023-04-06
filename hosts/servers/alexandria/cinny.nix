{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."cinny" = {
    image = "ghcr.io/cinnyapp/cinny:latest";
    ports = [ "${config.ports.cinny}:80" ];
    volumes = [ "/data/matrix/cinny-config.json:/app/config.json" ];
    extraOptions = [ "--pull=always" ];
  };

  services.nginx.virtualHosts."cinny.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.cinny}";
  };
}
