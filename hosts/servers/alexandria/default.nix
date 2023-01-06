{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./virtualisation.nix
    ./variables.nix
    ./services.nix
    ./security.nix
    ./users.nix
  ];
}
