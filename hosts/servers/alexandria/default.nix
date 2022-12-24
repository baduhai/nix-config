{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hosted-services.nix
    ./security.nix
    ./system.nix
    ./users.nix
  ];
}
