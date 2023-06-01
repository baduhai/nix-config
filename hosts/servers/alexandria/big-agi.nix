{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."big-agi" = {
    image = "ghcr.io/enricoros/big-agi:main";
    ports = [ "${config.ports.big-agi}:3000" ];
    environmentFiles = [ config.age.secrets.big-agi-keys.path ];
    extraOptions = [ "--pull=always" ];
  };

  services.nginx.virtualHosts."chat.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.big-agi}";
  };

  age.secrets.big-agi-keys = {
    file = ../../../secrets/big-agi-keys.age;
    owner = "root";
    group = "root";
  };
}
