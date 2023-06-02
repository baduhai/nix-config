{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."gptnw" = {
    image = "yidadaa/chatgpt-next-web";
    ports = [ "${config.ports.gptnw}:3000" ];
    environmentFiles = [ config.age.secrets.gptnw-keys.path ];
    extraOptions = [ "--pull=always" ];
  };

  services.nginx.virtualHosts."chat.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.gptnw}";
  };

  age.secrets.gptnw-keys = {
    file = ../../../secrets/gptnw-keys.age;
    owner = "root";
    group = "root";
  };
}
