{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./variables.nix
    ./services.nix
    ./security.nix
    ./users.nix
  ];
}
