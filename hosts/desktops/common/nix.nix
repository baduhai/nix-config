{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [
      "nixpkgs=/etc/channels/nixpkgs"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
