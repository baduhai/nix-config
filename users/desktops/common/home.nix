{ config, pkgs, lib, ... }:

{
  home = {
    pointerCursor = {
      size = 24;
      gtk.enable = true;
      x11.enable = true;
      name = "breeze_cursors";
      package = pkgs.breeze-icons;
    };
    file = {
      ".config/lite-xl/fonts/icon-nerd-font.ttf".source =
        config.lib.file.mkOutOfStoreSymlink
        "/var/run/current-system/sw/share/X11/fonts/HackNerdFontMono-Regular.ttf";
      # Autostart programs
      ".config/autostart/koi.desktop".source =
        config.lib.file.mkOutOfStoreSymlink
        "/var/run/current-system/sw/share/applications/koi.desktop";
    };
  };
}
