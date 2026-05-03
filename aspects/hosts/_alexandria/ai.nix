{ inputs, pkgs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
  openWebUiPort = 8080;
in

{
  services.nginx.virtualHosts = mkNginxVHosts {
    domains = {
      "ai.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:${toString openWebUiPort}/";
    };
  };

  services.open-webui = {
    enable = true;
    package = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.open-webui;
    host = "127.0.0.1";
    port = openWebUiPort;
    environment = {
      WEBUI_URL = "https://ai.baduhai.dev";
    };
  };
}
