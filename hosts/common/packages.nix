{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    agenix
    bind
    btop
    fastfetch
    git
    helix
    killall
    sysz
    tmux
    wget
  ];

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
  };
}
