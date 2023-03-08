{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    any-nix-shell
    bind
    btop
    comma
    git
    lazydocker
    micro
    neofetch
    sysz
    tmux
    tree
    wget
    zellij
  ];

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
  };
}
