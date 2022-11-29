{ inputs, config, pkgs, lib, ... }:

{
  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [
      "nixpkgs=/etc/channels/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
