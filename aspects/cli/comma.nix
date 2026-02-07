{ ... }:
{
  flake.modules.homeManager.cli-comma = { config, lib, pkgs, inputs, ... }: {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];

    programs.nix-index-database.comma.enable = true;
  };
}
