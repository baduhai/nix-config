{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."snapdrop" = {
    image = "lscr.io/linuxserver/pairdrop:latest";
    ports = [ "${config.ports.snapdrop}:3000" ];
    extraOptions = [ "--pull=always" ];
  };

  services.nginx.virtualHosts."snapdrop.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.snapdrop}";
  };
}

