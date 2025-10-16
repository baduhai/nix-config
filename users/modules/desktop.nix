{ inputs, pkgs, ... }:

{
  imports = [ inputs.dms.homeModules.dankMaterialShell.default ];

  fonts.fontconfig.enable = true;

  programs = {
    dankMaterialShell = {
      enable = true;
      enableVPN = false;
    };

    rio = {
      enable = true;
      settings = {
        theme = "catppuccin-mocha";
        fonts = {
          family = "FiraCode Nerd Font";
          size = 16.0;
          emoji.family = "Noto Color Emoji";
        };
        confirm-before-quit = false;
        window = {
          width = 1121;
          height = 633;
        };
      };
    };

    ghostty = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    password-store = {
      enable = true;
      package = pkgs.pass-wayland;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config.common.default = "*";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-decoration-layout = "appmenu:";
    };
    gtk4.extraConfig = {
      gtk-decoration-layout = "appmenu:";
    };
  };
}
