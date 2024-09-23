{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  virtualisation.oci-containers.containers."librespeed" = {
    image = "lscr.io/linuxserver/librespeed:latest";
    environment = {
      TZ = "America/Bahia";
    };
    ports = [ "${config.ports.librespeed}:80" ];
    extraOptions = [
      "--pull=newer"
      "--label=io.containers.autoupdate=registry"
    ];
  };

  services.nginx.virtualHosts."librespeed.baduhai.dev" = {
    useACMEHost = "baduhai.dev";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.librespeed}";
  };
}
