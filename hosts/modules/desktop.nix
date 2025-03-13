{
  hostType,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
      services = {
        displayManager.sddm = {
          enable = true;
          wayland = {
            enable = true;
            compositor = "kwin";
          };
        };
        keyd = {
          enable = true;
          keyboards.all = {
            ids = [ "*" ];
            settings.main.capslock = "overload(meta, esc)";
          };
        };
        desktopManager.plasma6.enable = true;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
          wireplumber.enable = true;
        };
      };

      hardware = {
        xpadneo.enable = true;
        bluetooth.enable = true;
        steam-hardware.enable = true; # Allow steam client to manage controllers
        graphics.enable32Bit = true; # For OpenGL games
        i2c.enable = true;
      };

      security.rtkit.enable = true; # Needed for pipewire to acquire realtime priority

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };
    })
  ];
}
