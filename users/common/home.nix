{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "micro";
    };
    file = {
      ".config/btop/themes/catppuccin_mocha.theme".source = "${inputs.dotfiles}/.config/btop/themes/catppuccin_mocha.theme";
      ""
    };
  };
}
