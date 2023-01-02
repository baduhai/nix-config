{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hosted-services.nix
    ./security.nix
    ./users.nix
    ./services
  ];
}
