{ ... }:
{
  flake.modules = {
    nixos.stylix =
      { inputs, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];
      };

    homeManager.stylix =
      {
        config,
        inputs,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.stylix.homeModules.stylix
          inputs.zen-browser.homeModules.beta
        ];

        stylix = {
          enable = true;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyodark.yaml";
          cursor = {
            package = pkgs.kdePackages.breeze;
            name = "breeze_cursors";
            size = 24;
          };
          icons = {
            enable = true;
            package = pkgs.morewaita-icon-theme;
            light = "MoreWaita";
            dark = "MoreWaita";
          };
          opacity = {
            applications = 1.0;
            desktop = 1.0;
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
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
            sizes = {
              applications = 10;
              desktop = config.stylix.fonts.sizes.applications;
              popups = config.stylix.fonts.sizes.applications;
              terminal = 12;
            };
          };
          targets.zen-browser = {
            enable = true;
            profileNames = [ "william" ];
          };
        };

        programs.zen-browser = {
          enable = true;
          profiles.william = { };
        };
      };
  };
}
