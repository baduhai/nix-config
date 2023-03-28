{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./containerised.nix
    ./variables.nix
    ./services.nix
    ./security.nix
    ./matrix.nix
    ./users.nix
  ];
}
