{ ... }:

{
  imports = [
    ./containerised.nix
    ./hardware-configuration.nix
    ./matrix.nix
    ./security.nix
    ./services.nix
    ./users.nix
    ./variables.nix
  ];
}
