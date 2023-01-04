{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./security.nix
    ./users.nix
    ./services
  ];
}
