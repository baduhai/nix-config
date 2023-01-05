{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services = {
    qbittorrent = {
      enable = true;
      user = "user";
      group = "hosted";
      port = lib.toInt "${config.ports.qbittorrent}";
    };

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

    jackett.enable = true;
  };
}
