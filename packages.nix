{ ... }:

{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        toggleaudiosink = pkgs.callPackage ./packages/toggleaudiosink.nix { };
        hm-cli = pkgs.callPackage ./packages/hm-cli.nix { };
      };
    };
}
