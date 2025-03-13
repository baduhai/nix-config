{ ... }:

{
  imports = [
    ./boot
    ./ephermal.nix
    ./hardware-configuration.nix
    ./programs.nix
    ./services.nix
  ];
}
