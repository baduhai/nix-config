{ config, pkgs, lib, ... }:

{
  services = {
    kdeconnect.enable = true;
    syncthing = {
      enable = true;
      tray = {
        enable = true;
        package = pkgs.writeShellScriptBin "syncthingtray" "exec ${pkgs.syncthingtray}/bin/syncthingtray --wait" // { pname = "syncthingtray"; }; # Override synctray so it waits for a system tray
      };
    };
  };
}
