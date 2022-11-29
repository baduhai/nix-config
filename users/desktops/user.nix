{ config, pkgs, lib, ... }:

{
  imports = [
    # Host-common imports
    ../common/programs.nix
    ../common/home.nix
    # Desktop-common imports
    ./common/programs.nix
    ./common/services.nix
    ./common/home.nix
  ];
}
