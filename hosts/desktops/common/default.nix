{ ... }:

{
  imports = [
    ./boot.nix
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
