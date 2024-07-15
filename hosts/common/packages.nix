{ inputs, config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    agenix
    bind
    btop
    git
    helix
    neofetch
    sysz
    tmux
    tree
    wget
  ];

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
  };
}
