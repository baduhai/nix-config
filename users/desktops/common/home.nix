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
    packages = with pkgs; [
      syncthingtray
    ];
    file = {
      # Dotfiles that can't be managed via home-manager
      ".local/share/color-schemes/BreezeDarkNeutral.colors".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/baduhai/dotfiles/master/color-schemes/BreezeDarkNeutral.colors";
        sha256 = "Fw5knhpV47HlgYvbHFzfi6M6Tk2DTlAuFUYc2WDDBc8=";
      };
      ".config/MangoHud/MangoHud.conf".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/baduhai/dotfiles/master/MangoHud/MangoHud.conf";
        sha256 = "WCRsS6njtU4aR7tMiX8oWa2itJyy04Zp7wfwV20SLZs=";
      };
      ".config/kitty/search.py".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/baduhai/dotfiles/master/kitty/search.py";
        sha256 = "mi5GB8CmWafAdp3GYnsQM4VHpXhuaVYX7YDT+9426Jc=";
      };
      ".config/kitty/scroll_mark.py".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/baduhai/dotfiles/master/kitty/scroll_mark.py";
        sha256 = "Abif6LIOCiXyDdQMZ4pQnLK++It0VYIM+WE7Oydwkfo=";
      };
      # Autostart programs
      ".config/autostart/org.kde.yakuake.desktop".source = config.lib.file.mkOutOfStoreSymlink "/var/run/current-system/sw/share/applications/org.kde.yakuake.desktop";
      ".config/autostart/megasync.desktop".source = config.lib.file.mkOutOfStoreSymlink "/var/run/current-system/sw/share/applications/megasync.desktop";
      ".config/autostart/koi.desktop".source = config.lib.file.mkOutOfStoreSymlink "/var/run/current-system/sw/share/applications/koi.desktop";
      # Fix flatpak fonts, themes, icons and cursor
      ".icons/breeze_cursors".source = config.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/icons/breeze_cursors";
      ".local/share/flatpak/overrides/global".text = "[Context]\nfilesystems=/run/current-system/sw/share/X11/fonts:ro;~/.local/share/color-schemes:ro;xdg-config/gtk-3.0:ro;/nix/store:ro;~/.icons:ro";
    };
  };
}
