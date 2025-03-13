{ ... }:

{
  imports = [
    ./boot.nix
    ./ephermal.nix
    ./hardware-configuration.nix
    ./programs.nix
    ./services.nix
  ];
}
