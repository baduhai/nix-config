{ config, pkgs, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://redlib.tux.pizza/img/z7t5x3p9olud1.png";
      sha256 = "sha256-MKPh/DHBWkXhmWJRShMCFtaN6uL4/opQ6flINQdQWeM=";
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
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
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
