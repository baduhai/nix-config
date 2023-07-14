{ inputs, config, pkgs, lib, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "micro";
      TZ = ":/etc/localtime";
    };
    file = {
      ".config/starship.toml".source =
        "${inputs.dotfiles}/.config/starship.toml";
    };
    packages = with pkgs; [ nix-your-shell ];
  };
}
