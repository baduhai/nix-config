{ ... }:

{
  networking.hostName = "rotterdam";

  imports = [
    ./modules/rotterdam
    ./modules
  ];

  nix.nixPath = [ "nixos-config=${./rotterdam.nix}" ];
}
