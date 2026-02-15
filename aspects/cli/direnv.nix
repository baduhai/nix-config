{ ... }:
{
  flake.modules.homeManager.direnv =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
