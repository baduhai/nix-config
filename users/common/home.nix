{ config, pkgs, lib, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
    sessionVariables = {
      TZ = ":/etc/localtime";
      EDITOR = "hx";
    };
    packages = with pkgs; [ nix-your-shell ];
  };
}
