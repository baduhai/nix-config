{ config, pkgs, inputs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  imports = [ inputs.fusion.nixosModules.default ];

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
