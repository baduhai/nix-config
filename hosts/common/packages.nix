{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bind
    btop
    comma
    git
    lazydocker
    micro
    neofetch
    nix-your-shell
    sysz
    tmux
    tree
    wget
    # Package overrides
    (nnn.override {
      withNerdIcons = true;
    })
  ];

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
  };
}
