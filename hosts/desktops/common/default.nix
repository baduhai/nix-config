{ ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./nix.nix
    ./packages.nix
    ./services.nix
    ./users.nix
    ./virtualisation.nix
  ];
}
