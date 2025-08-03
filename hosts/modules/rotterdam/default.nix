{ ... }:

{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./hardware.nix
    ./programs.nix
    ./services.nix
  ];
}
