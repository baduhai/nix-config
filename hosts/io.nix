{ ... }:

{
  networking.hostName = "io";

  imports = [
    ./modules/io
    ./modules/boot.nix
    ./modules/console.nix
    ./modules/desktop.nix
    ./modules/flatpak.nix
    ./modules/impermanence.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/nix.nix
    ./modules/programs.nix
    ./modules/security.nix
    ./modules/services.nix
    ./modules/users.nix
    ./modules/virtualisation.nix
  ];

  nix.nixPath = [ "nixos-config=${./io.nix}" ];
}
