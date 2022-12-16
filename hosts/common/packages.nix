{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    any-nix-shell
    bind
    btop
    git
    lazydocker
    micro
    neofetch
    tmux
    tree
    wget
  ];

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
  };

  console = {
    font = "Hack Nerd Font"
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
}
