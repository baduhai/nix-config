{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.oci-containers.containers."pairdrop" = {
    image = "lscr.io/linuxserver/pairdrop:latest";
    ports = [ "${config.ports.pairdrop}:3000" ];
    extraOptions = [ "--label=io.containers.autoupdate=registry" ];
  };
}

