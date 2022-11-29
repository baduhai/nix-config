{ config, pkgs, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    any-nix-shell
    bind
    btop
    git
    lazydocker
    micro
    tmux
    tree
    wget
  ];

  programs = {
    fish.enable = true;
  };
}
