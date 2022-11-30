{ config, pkgs, lib, ... }:

{
  imports = [
    # Host-common imports
    ../common/programs.nix
    ../common/home.nix
  ];
}
