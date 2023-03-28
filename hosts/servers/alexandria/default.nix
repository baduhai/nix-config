{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./containerised.nix
    ./variables.nix
    ./services.nix
    ./security.nix
    ./conduit.nix
    ./users.nix
  ];
}
