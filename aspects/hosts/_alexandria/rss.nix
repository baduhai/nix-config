{ config, pkgs, inputs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  imports = [ inputs.fusion.nixosModules.default ];

  services = {
    fusion = {
      enable = true;
      port = 58000;
      allowPrivateFeeds = true;
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev".locations."/".proxyPass = "http://localhost:58000/";
    };
  };
}
