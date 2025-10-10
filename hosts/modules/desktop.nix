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
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
          wireplumber.enable = true;
        };
        greetd.settings.initial_session = {
          command = "niri";
          user = "user";
        };
      };

      programs = {
        dankMaterialShell.greeter = {
          enable = true;
          compositor.name = "niri";
        };
        niri.enable = true;
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
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };
    })
  ];
}
