{ ... }:

{
  networking.hostName = "rotterdam";

  imports = [
    ./rotterdam
    ./modules
  ];

  nix.nixPath = [ "nixos-config=${./rotterdam.nix}" ];
}
