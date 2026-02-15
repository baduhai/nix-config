{ ... }:
{
  flake.modules.homeManager.bash =
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
