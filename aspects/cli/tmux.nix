{ ... }:
{
  flake.modules = {
    nixos.tmux =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          tmux
        ];
      };

    homeManager.tmux =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        programs.tmux = {
          enable = true;
          clock24 = true;
          terminal = "xterm-256color";
          mouse = true;
          keyMode = "vi";
        };
      };
  };
}
