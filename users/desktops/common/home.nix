{ specialArgs, inputs, config, pkgs, lib, ... }:

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
      ".local/share/color-schemes/CatppuccinMocha.colors".source = "${inputs.dotfiles}/CatppuccinMocha.colors";
      ".local/share/color-schemes/CatppuccinLatte.colors".source = "${inputs.dotfiles}/CatppuccinLatte.colors";
      ".config/wezterm/wezterm.lua".source = "${inputs.dotfiles}/wezterm.lua";
      ".config/MangoHud/MangoHud.conf".source = "${inputs.dotfiles}/MangoHud/MangoHud.conf";
      # Autostart programs
      ".config/autostart/org.kde.yakuake.desktop".source = config.lib.file.mkOutOfStoreSymlink "/var/run/current-system/sw/share/applications/org.kde.yakuake.desktop";
      ".config/autostart/koi.desktop".source = config.lib.file.mkOutOfStoreSymlink "/var/run/current-system/sw/share/applications/koi.desktop";
    };
  };
}
