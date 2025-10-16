{ inputs, pkgs, ... }:

{
  imports = [ inputs.dms.homeModules.dankMaterialShell.default ];

  fonts.fontconfig.enable = true;

  programs = {
    dankMaterialShell = {
      enable = true;
      enableVPN = false;
    };

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
        theme = "Banana Blueberry";
        window-theme = "ghostty";
        bell-features = "border";
      };
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
