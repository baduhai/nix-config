{ ... }:

{
  networking.hostName = "io";

  imports = [
    ./modules
    ./io
  ];

  nix.nixPath = [ "nixos-config=${./io.nix}" ];
}
