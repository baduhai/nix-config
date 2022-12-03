{ inputs, config, pkgs, lib, ... }:

{
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs-stable.outPath;

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs-stable;
    nixPath = [
      "nixpkgs=/etc/channels/nixpkgs"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
