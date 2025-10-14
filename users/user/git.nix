{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
    userName = "William";
    userEmail = "baduhai@proton.me";
  };
}