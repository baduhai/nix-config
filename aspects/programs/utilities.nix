{ ... }:

{
  flake.modules = {
    nixos.programs-utilities =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          ghostty
          gnome-disk-utility
          mission-center
          nautilus
          p7zip
          rclone
          unrar
          # Desktop Integration
          adwaita-icon-theme
          junction
          libfido2
          toggleaudiosink
          # Xwayland Support
          xwayland-satellite
        ];

        services.flatpak.packages = [
          "com.github.tchx84.Flatseal"
          "com.rustdesk.RustDesk"
        ];
      };

    homeManager.programs-utilities =
      { pkgs, ... }:
      {
        programs = {
          ghostty = {
            enable = true;
            settings = {
              cursor-style = "block";
              shell-integration-features = "no-cursor";
              cursor-style-blink = false;
              custom-shader = "${builtins.fetchurl {
                url = "https://raw.githubusercontent.com/hackr-sh/ghostty-shaders/cb6eb4b0d1a3101c869c62e458b25a826f9dcde3/cursor_blaze.glsl";
                sha256 = "sha256:0g2lgqjdrn3c51glry7x2z30y7ml0y61arl5ykmf4yj0p85s5f41";
              }}";
              bell-features = "";
              gtk-titlebar-style = "tabs";
              keybind = [ "shift+enter=text:\\x1b\\r" ];
            };
          };

          password-store = {
            enable = true;
            package = pkgs.pass-wayland;
          };
        };

        home.sessionVariables = {
          TERMINAL = "ghostty";
        };
      };
  };
}
