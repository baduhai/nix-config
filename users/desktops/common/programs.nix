{ inputs, config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 10;
    };
    theme = {
      package = pkgs.breeze-gtk;
      name = "Breeze";
    };
    iconTheme = {
      package = pkgs.breeze-icons;
      name = "Breeze";
    };
  };

  programs = {
    password-store.package = pkgs.pass-wayland;
    mangohud = {
      enable = true;
      enableSessionWide = true;
    };
    obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.obs-vkcapture
        pkgs.obs-studio-plugins.obs-backgroundremoval
        pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
    fish = {
      functions = {
        rebuild =
          "sudo nixos-rebuild switch --flake '/home/user/Projects/personal/nix-config#'";
        rebuild-boot =
          "sudo nixos-rebuild boot --flake '/home/user/Projects/personal/nix-config#'";
        update =
          "nix flake update --commit-lock-file /home/user/Projects/personal/nix-config";
        hm-rebuild =
          "rm ~/.gtkrc-2.0; nix run '/home/user/Projects/personal/nix-config#homeConfigurations.desktop.activationPackage'";
      };
    };
  };
}
