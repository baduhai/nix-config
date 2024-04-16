{ config, pkgs, lib, ... }:

let
  plasma = pkgs.writeScriptBin "plasma" ''
    ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland &> /dev/null
  '';

in {
  services = {
    flatpak.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ epson-escpr ];
    };
    udev.packages = with pkgs; [ platformio openocd yubikey-personalization ];
    desktopManager.plasma6.enable = true;
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
      displayManager.startx.enable = true;
    };
    greetd = {
      enable = true;
      settings = {
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --time --greeting "Welcome to NixOS" --cmd ${plasma}/bin/plasma'';
        initial_session = {
          command = "${plasma}/bin/plasma";
          user = "user";
        };
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde xdg-desktop-portal-gtk ];
  };
}
