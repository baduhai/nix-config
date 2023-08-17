{ inputs, config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    agenix
    bind
    btop
    comma
    git
    helix
    micro
    neofetch
    # nix-your-shell # Currently only available in unstable
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
