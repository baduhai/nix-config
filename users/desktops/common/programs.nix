{ specialArgs, inputs, config, pkgs, lib, ... }:

let
  fontFamily = "Hack Nerd Font";
in

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
      userEmail = "baduhai@proton.me";
    };
    fish = {
      functions = {
        rebuild = "rm ~/.gtkrc-2.0; sudo nixos-rebuild switch --flake '/home/user/Projects/personal/nix-config#'";
        rebuild-boot = "rm ~/.gtkrc-2.0; sudo nixos-rebuild boot --flake '/home/user/Projects/personal/nix-config#'";
        upgrade = "rm ~/.gtkrc-2.0; nix flake lock --update-input nixpkgs --commit-lock-file /home/user/Projects/personal/nix-config; sudo nixos-rebuild switch --upgrade --flake '/home/user/Projects/personal/nix-config#'";
        upgrade-boot = "rm ~/.gtkrc-2.0; nix flake lock --update-input nixpkgs --commit-lock-file /home/user/Projects/personal/nix-config; sudo nixos-rebuild boot --upgrade --flake '/home/user/Projects/personal/nix-config#'";
      };
    };
  };
}
