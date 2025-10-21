{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;
  utils = import ./utils.nix { inherit inputs lib; };
  inherit (utils) mkTerranixDerivation;

  configs = {
    # Example:
    # myconfig = {
    #   modules = [ ./terraform/myconfig.nix ];
    # };
  };
in

{
  perSystem =
    { system, ... }:
    {
      packages = mkTerranixDerivation { inherit system configs; };
    };
}
