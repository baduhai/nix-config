{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."librespeed" = {
    image = "lscr.io/linuxserver/librespeed:latest";
    environment = { TZ = "America/Bahia"; };
    ports = [ "${config.ports.librespeed}:80" ];
    extraOptions = [ "--label=io.containers.autoupdate=registry" ];
  };

  services.nginx.virtualHosts."librespeed.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.librespeed}";
  };
}
