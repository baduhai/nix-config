{ lib, config, inputs, ... }:
let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      open-webui = (import inputs.nixpkgs {
        inherit (prev) system;
        config.allowUnfree = true;
      }).open-webui;
    })
  ];

  services.open-webui = {
    enable = true;
    environment = {
      SCARF_NO_ANALYTICS = "True";
      DO_NOT_TRACK = "True";
      ANONYMIZED_TELEMETRY = "False";
    };
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."ai.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:8080/";
  };
}
