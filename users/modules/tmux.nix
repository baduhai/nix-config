{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "xterm-256color";
    mouse = true;
    keyMode = "vi";
  };
}