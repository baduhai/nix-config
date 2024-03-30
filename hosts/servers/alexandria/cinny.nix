{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."cinny" = {
    image = "ghcr.io/cinnyapp/cinny:latest";
    ports = [ "${config.ports.cinny}:80" ];
    environment = { TZ = "America/Bahia"; };
    volumes = [ "/data/matrix/cinny-config.json:/app/config.json" ];
    extraOptions = [ "--pull=newer --label=io.containers.autoupdate=registry" ];
  };

  services.nginx.virtualHosts."cinny.baduhai.dev" = {
    useACMEHost = "baduhai.dev";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.cinny}";
  };
}
