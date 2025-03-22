{ ... }:

{
  networking.hostName = "io";

  imports = [
    ./modules/io
    ./modules
  ];

  nix.nixPath = [ "nixos-config=${./io.nix}" ];
}
