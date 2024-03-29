{ config, pkgs, lib, ... }:

{
  home = {
    pointerCursor = {
      size = 24;
      gtk.enable = true;
      x11.enable = true;
      name = "Breeze_Light";
      package = pkgs.kdePackages.breeze-icons;
    };
    activation.removeExistingGtk =
      lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        rm -rf ~/.gtkrc-2.0
        rm -rf ~/.config/gtk-3.0
        rm -rf ~/.config/gtk-4.0
      '';
  };
}
