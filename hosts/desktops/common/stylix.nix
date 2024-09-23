{ config, pkgs, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/notAxon/wallpapers/blob/main/Nature/Pink_Flowers_Photograph_by_Lisa_Fotios.jpeg?raw=true";
      sha256 = "sha256-PyK/LuR7IR+FpGFZXdpYkShjKrwaqCtu64SY/wl/RvY=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      package = pkgs.kdePackages.breeze-icons;
      name = "Breeze_Light";
      size = 24;
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
        package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
        name = "Hack Nerd Font";
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
