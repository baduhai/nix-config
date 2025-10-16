{ lib, inputs, ... }:
let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
in
{
  virtualisation.oci-containers.containers."librespeed" = {
    image = "lscr.io/linuxserver/librespeed:latest";
    environment = {
      TZ = "America/Bahia";
    };
    extraOptions = [
      "--pull=newer"
      "--label=io.containers.autoupdate=registry"
    ];
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    acmeHost = "baduhai.dev";
    domains."speedtest.baduhai.dev".locations."/".proxyPass = "http://librespeed:80/";
  };
}
