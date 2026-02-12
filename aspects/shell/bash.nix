{ ... }:
{
  flake.modules.homeManager.shell-bash =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.bash = {
        enable = true;
        historyFile = "~/.cache/bash_history";
      };
    };
}
