{ ... }:

{
  networking.hostName = "alexandria";

  imports = [
    ./modules/alexandria
    ./modules/boot.nix
    ./modules/console.nix
    ./modules/desktop.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/nix.nix
    ./modules/programs.nix
    ./modules/security.nix
    ./modules/services.nix
    ./modules/users.nix
    ./modules/virtualisation.nix
  ];

  nix.nixPath = [ "nixos-config=${./alexandria.nix}" ];
}
