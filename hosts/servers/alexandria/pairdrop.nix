{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."pairdrop" = {
    image = "lscr.io/linuxserver/pairdrop:latest";
    ports = [ "${config.ports.pairdrop}:3000" ];
    extraOptions = [ "--pull=always" ];
  };

  services.nginx.virtualHosts."pairdrop.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.pairdrop}";
  };
}

