{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = { name = "Inter"; size = 10; };
    theme = { package = pkgs.breeze-gtk; name = "Breeze"; };
    iconTheme = { package = pkgs.breeze-icons; name = "Breeze"; };
  };

  programs = {
    password-store.package = pkgs.pass-wayland;
    mangohud = {
      enable = true;
      enableSessionWide = true;
    };
    git = {
      enable = true;
      diff-so-fancy.enable = true;
      userName = "William";
      userEmail = "williamhai@hotmail.com";
    };
    fish = {
      functions = {
        rebuild = "rm ~/.gtkrc-2.0; sudo nixos-rebuild switch --flake '/home/user/Projects/personal/nix-config#'";
        rebuild-boot = "rm ~/.gtkrc-2.0; sudo nixos-rebuild boot --flake '/home/user/Projects/personal/nix-config#'";
        upgrade = "rm ~/.gtkrc-2.0; nix flake lock --update-input nixpkgs --commit-lock-file /home/user/Projects/personal/nix-config; sudo nixos-rebuild switch --upgrade --flake '/home/user/Projects/personal/nix-config#'";
        upgrade-boot = "rm ~/.gtkrc-2.0; nix flake lock --update-input nixpkgs --commit-lock-file /home/user/Projects/personal/nix-config; sudo nixos-rebuild boot --upgrade --flake '/home/user/Projects/personal/nix-config#'";
      };
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_dark.theme";
        theme_background = false;
        proc_sorting = "cpu direct";
        update_ms = 500;
      };
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'
        return {
          font_size = 10,
          color_scheme = 'Twilight (base16)',
          hide_tab_bar_if_only_one_tab = true,
          font = wezterm.font_with_fallback ({
            "Hack Nerd Font",
            "Noto Color Emoji",
          }),
          initial_cols = 120,
          initial_rows = 34,
        }
      '';
    };
  };
}
