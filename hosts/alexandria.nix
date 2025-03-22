{ ... }:

{
  networking.hostName = "alexandria";

  imports = [
    ./modules/alexandria
    ./modules
  ];

  nix.nixPath = [ "nixos-config=${./alexandria.nix}" ];
}
