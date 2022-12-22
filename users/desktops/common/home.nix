{ inputs, config, pkgs, lib, ... }:

{
  home = {
    pointerCursor = {
      size = 24;
      gtk.enable = true;
      x11.enable = true;
      name = "breeze_cursors";
      package = pkgs.breeze-icons;
    };
    packages = with pkgs; [
      syncthingtray
    ];
    file = {
      # Dotfiles that can't be managed via home-manager
      ".local/share/color-schemes/BreezeDarkNeutral.colors".source = "${inputs.dotfiles}/color-schemes/BreezeDarkNeutral.colors";
      ".config/MangoHud/MangoHud.conf".source = "${inputs.dotfiles}/MangoHud/MangoHud.conf";
      ".config/kitty/search.py".source = "${inputs.dotfiles}/kitty/search.py";
      ".config/kitty/scroll_mark.py".source = "${inputs.dotfiles}/kitty/scroll_mark.py";
      # Autostart programs
      ".config/autostart/org.kde.yakuake.desktop".source = config.lib.file.mkOutOfStoreSymlink "/var/run/current-system/sw/share/applications/org.kde.yakuake.desktop";
      ".config/autostart/koi.desktop".source = config.lib.file.mkOutOfStoreSymlink "/var/run/current-system/sw/share/applications/koi.desktop";
      # Fix flatpak fonts, themes, icons and cursor
      ".icons/breeze_cursors".source = config.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/icons/breeze_cursors";
      ".local/share/flatpak/overrides/global".text = "[Context]\nfilesystems=/run/current-system/sw/share/X11/fonts:ro;~/.local/share/color-schemes:ro;xdg-config/gtk-3.0:ro;/nix/store:ro;~/.icons:ro";
    };
  };
}
