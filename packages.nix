{ ... }:

{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        toggleaudiosink = pkgs.callPackage ./packages/toggleaudiosink.nix { };
      };
    };
}
