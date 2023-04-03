{ inputs, config, pkgs, lib, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
    sessionVariables = { EDITOR = "micro"; };
    file = {
      ".config/starship.toml".source =
        "${inputs.dotfiles}/.config/starship.toml";
    };
  };
}
