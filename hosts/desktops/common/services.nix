{ config, pkgs, lib, ... }:

let
  plasma = pkgs.writeScriptBin "plasma" ''
    ${pkgs.plasma-workspace}/bin/startplasma-wayland &> /dev/null
  '';

in {
  services = {
    flatpak.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ epson-escpr ];
    };
    udev.packages = with pkgs; [ platformio openocd yubikey-personalization ];
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
      exportConfiguration = true;
      excludePackages = (with pkgs; [ xterm ]);
      displayManager = {
        defaultSession = "plasmawayland";
        sddm = {
          enable = true;
          wayland = {
            enable = true;
            compositorCommand =
              "${pkgs.kwin}/bin/kwin_wayland --no-global-shortcuts --no-lockscreen --locale1";
          };
          settings = {
            Theme = {
              CursorTheme = "breeze_cursors";
              CursorSize = "24";
            };
            General = {
              GreeterEnvironment =
                "QT_PLUGIN_PATH=${pkgs.plasma5Packages.layer-shell-qt}/${pkgs.plasma5Packages.qtbase.qtPluginPrefix},QT_WAYLAND_SHELL_INTEGRATION=layer-shell,XKB_DEFAULT_KEYMAP=us,XKB_DEFAULT_VARIANT=altgr-intl";
              InputMethod = "";
            };
          };
        };
      };
      desktopManager.plasma5.enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
