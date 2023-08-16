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
}
