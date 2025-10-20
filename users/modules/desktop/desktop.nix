{
  config,
  inputs,
  pkgs,
  ...
}:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [ xwayland-satellite ];

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
        bell-features = "border";
        gtk-titlebar-style = "tabs";
        keybind = [ "shift+enter=esc:\\x1b[13;2u" ];
      };
    };

    password-store = {
      enable = true;
      package = pkgs.pass-wayland;
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
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

  xdg = {
    enable = true;
    userDirs.enable = true;
  };
}
