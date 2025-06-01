{ ... }:

{
  networking.hostName = "trantor";

  imports = [
    ./modules/trantor
    ./modules
  ];

  nix.nixPath = [ "nixos-config=${./trantor.nix}" ];
}

