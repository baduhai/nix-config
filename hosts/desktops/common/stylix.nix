{ config, pkgs, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://images.unsplash.com/photo-1701453831008-ea11046da960?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=nat-uN9OSpSsw4A-unsplash.jpg";
      sha256 = "sha256-89o5VYI4cMP/O33oCaHi61hUYmIWEdyr8uGf/b2DMUk=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      package = pkgs.kdePackages.breeze-icons;
      name = "Breeze_Light";
      size = 24;
    };
    opacity = {
      applications = 1.0;
      desktop = 0.8;
      popups = config.stylix.opacity.desktop;
      terminal = 1.0;
    };
    fonts = {
      serif = {
        package = pkgs.source-serif;
        name = "Source Serif 4 Display";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 10;
        desktop = config.stylix.fonts.sizes.applications;
        popups = config.stylix.fonts.sizes.applications;
        terminal = 12;
      };
    };
  };
}
