{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services = {
    jellyfin = {
      enable = true;
      group = "hosted";
    };

    radarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    sonarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    bazarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    aria2.enable = true;

    jackett.enable = true;
  };
}
