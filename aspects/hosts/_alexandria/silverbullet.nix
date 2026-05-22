{ config, inputs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services = {
    silverbullet = {
      enable = true;
      listenAddress = "127.0.0.1";
      listenPort = 58002;
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."notes.baduhai.dev".locations."/".proxyPass =
        "http://${config.services.silverbullet.listenAddress}:${toString config.services.silverbullet.listenPort}/";
    };
  };
}
