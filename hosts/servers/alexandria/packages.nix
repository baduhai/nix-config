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
    htop
    lazydocker
    micro
    tmux
    wget
  ];
}
