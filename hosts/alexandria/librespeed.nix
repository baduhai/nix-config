{
  config,
  lib,
  inputs,
  ...
}:

let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
in

{
  systemd.services.init-librespeed-network = {
    description = "Create the network bridge for librespeed.";
    after = [ "network.target" ];
    wantedBy = [ "podman-librespeed.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      check=$(${config.virtualisation.podman.package}/bin/podman network ls | grep "librespeed" || true)
      if [ -z "$check" ]; then
        ${config.virtualisation.podman.package}/bin/podman network create librespeed
      else
        echo "librespeed network already exists"
      fi
    '';
  };

  virtualisation.oci-containers.containers."librespeed" = {
    image = "lscr.io/linuxserver/librespeed:latest";
    environment = {
      TZ = "America/Bahia";
    };
    networks = [ "librespeed" ];
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
