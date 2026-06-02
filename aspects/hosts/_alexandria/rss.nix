{ config, pkgs, inputs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services = {
    fusion = {
      enable = true;
      package = inputs.fusion.packages.${pkgs.system}.default;
      port = 58000;
      allowPrivateFeeds = true;
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev".locations."/".proxyPass = "http://localhost:58000/";
    };
  };
}
