{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    historyFile = "~/.cache/bash_history";
  };
}