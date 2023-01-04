{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services = {
    jellyfin = {
      enable = true;
      group = "hosted";
    };

    radarr = {
      enable = true;
      group = "hosted";
    };

    sonarr = {
      enable = true;
      group = "hosted";
    };

    bazarr = {
      enable = true;
      group = "hosted";
    };

    prowlarr.enable = true;
  };
}
