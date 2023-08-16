{ inputs, config, pkgs, lib, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
    sessionVariables = {
      TZ = ":/etc/localtime";
      EDITOR = "nvim";
    };
    file = {
      ".config/starship.toml".source =
        "${inputs.dotfiles}/.config/starship.toml";
    };
    packages = with pkgs; [ nix-your-shell ];
  };
}
