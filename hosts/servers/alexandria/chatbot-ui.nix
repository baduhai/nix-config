{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."chatbot-ui" = {
    image = "ghcr.io/mckaywrigley/chatbot-ui:main";
    ports = [ "${config.ports.chatbot-ui}:3000" ];
    environmentFiles = [ config.age.secrets.chatbot-ui-keys.path ];
    extraOptions = [ "--pull=always" ];
  };

  services.nginx.virtualHosts."chat.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.chatbot-ui}";
  };

  age.secrets.chatbot-ui-keys = {
    file = ../../../secrets/chatbot-ui-keys.age;
    owner = "root";
    group = "root";
  };
}
