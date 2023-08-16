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
    file = {
      ".config/wezterm/wezterm.lua".source =
        "${inputs.dotfiles}/.config/wezterm/wezterm.lua";
      ".config/MangoHud/MangoHud.conf".source =
        "${inputs.dotfiles}/.config/MangoHud/MangoHud.conf";
      ".config/solvespace/settings.json".source =
        "${inputs.dotfiles}/.config/solvespace/settings.json";
      ".config/lite-xl/fonts/icon-nerd-font.ttf".source =
        config.lib.file.mkOutOfStoreSymlink
        "/var/run/current-system/sw/share/X11/fonts/HackNerdFontMono-Regular.ttf";
      # Autostart programs
      ".config/autostart/koi.desktop".source =
        config.lib.file.mkOutOfStoreSymlink
        "/var/run/current-system/sw/share/applications/koi.desktop";
    };
  };
  xdg.desktopEntries.emacsd = {
    name = "Emacs";
    exec = "${config.services.emacs.package}/bin/emacsclient -c";
    icon = "emacs";
    comment = "More than just a text editor";
    genericName = "Text Editor";
    mimeType = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
    categories = [ "Development" "TextEditor" ];
  };
}
