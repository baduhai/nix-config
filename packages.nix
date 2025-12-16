{ inputs, ... }:

{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages = {
        base16-schemes = pkgs.callPackage ./packages/base16-schemes.nix { };
        claude-desktop = pkgs.callPackage ./packages/claude-desktop.nix { };
        fastfetch = pkgs.callPackage ./packages/fastfetch.nix { };
        hm-cli = pkgs.callPackage ./packages/hm-cli.nix { };
        kwrite = pkgs.callPackage ./packages/kwrite.nix { };
        toggleaudiosink = pkgs.callPackage ./packages/toggleaudiosink.nix { };
      };
    };
}
