{ ... }:

{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        base16-schemes = pkgs.callPackage ./packages/base16-schemes.nix { };
        fastfetch = pkgs.callPackage ./packages/fastfetch.nix { };
        hm-cli = pkgs.callPackage ./packages/hm-cli.nix { };
        kwrite = pkgs.callPackage ./packages/kwrite.nix { };
        toggleaudiosink = pkgs.callPackage ./packages/toggleaudiosink.nix { };
      };
    };
}
