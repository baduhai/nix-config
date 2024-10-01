{ pkgs, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "hx";
    };
    packages = with pkgs; [ nix-your-shell ];
  };
}
