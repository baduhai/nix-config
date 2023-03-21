{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./virtualisation.nix
    ./containerised.nix
    ./variables.nix
    ./services.nix
    ./security.nix
    ./users.nix
  ];
}
