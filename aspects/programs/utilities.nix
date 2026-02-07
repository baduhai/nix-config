{ ... }:

{
  flake.modules = {
    nixos.programs-utilities = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        # Terminal
        ghostty
        # File Management
        nautilus
        gnome-disk-utility
        # Archive Tools
        p7zip
        unrar
        # Cloud & Remote
        rclone
        # System Monitoring
        mission-center
        # Desktop Integration
        adwaita-icon-theme
        junction
        libfido2
        toggleaudiosink
        # Xwayland Support
        xwayland-satellite
      ];

      services.flatpak.packages = [
        # Flatpak Management
        "com.github.tchx84.Flatseal"
        # Remote Desktop
        "com.rustdesk.RustDesk"
      ];
    };

    homeManager.programs-utilities = { pkgs, ... }: {
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
