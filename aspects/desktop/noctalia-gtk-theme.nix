{ ... }:

{
  flake.modules.homeManager.noctaliaGtkTheme =
    { pkgs, ... }:
    let
      # Noctalia syncs the GNOME color-scheme preference, which GTK4/libadwaita,
      # browsers and portals follow. It does not touch the GTK theme name, so
      # GTK3 (via GDK's GSettings lookup) stays on whichever adw-gtk3 variant
      # it last saw. Switch that variant whenever the resolved mode changes,
      # and once at startup.
      gtkThemeSync = pkgs.writeShellApplication {
        name = "noctalia-gtk-theme-sync";
        runtimeInputs = with pkgs; [
          dconf
          glib
        ];
        text = ''
          set -euo pipefail

          mode="''${NOCTALIA_THEME_MODE:-}"
          if [ -z "$mode" ]; then
            mode="$(noctalia msg theme-mode-get 2>/dev/null || true)"
          fi

          case "$mode" in
            light) gtk_theme="adw-gtk3" ;;
            dark) gtk_theme="adw-gtk3-dark" ;;
            *) exit 0 ;;
          esac

          if command -v dconf >/dev/null; then
            dconf write /org/gnome/desktop/interface/gtk-theme "'$gtk_theme'"
          else
            gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
          fi
        '';
      };
    in
    {
      home.packages = [ gtkThemeSync ];

      # Noctalia merges every *.toml in ~/.config/noctalia. GUI changes land in
      # ~/.local/state/noctalia/settings.toml, which still wins over this file.
      xdg.configFile."noctalia/config.toml".text = ''
        [hooks]
        started = "${gtkThemeSync}/bin/noctalia-gtk-theme-sync"
        theme_mode_changed = "${gtkThemeSync}/bin/noctalia-gtk-theme-sync"
      '';
    };
}
