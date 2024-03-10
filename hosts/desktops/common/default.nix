{ ... }:

{
  imports = [
    ./boot.nix
    ./flatpakfix.nix
    ./hardware.nix
    ./home-manager.nix
    ./impermanence.nix
    ./nix.nix
    ./packages.nix
    ./services.nix
    ./users.nix
    ./virtualisation.nix
  ];
}
