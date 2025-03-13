{ ... }:

{
  imports = [
    ./boot.nix
    ./ephermal.nix
    ./hardware-configuration.nix
    ./hardware.nix
    ./programs.nix
    ./services.nix
  ];
}
