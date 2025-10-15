{ ... }:

{
  flake.nixosModules = {
    ephemeral = import ./modules/ephemeral.nix;
  };
}
