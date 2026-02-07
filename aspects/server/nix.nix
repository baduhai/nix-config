# aspects/server/nix.nix
{ inputs, ... }:
{
  flake.modules.nixos.server-nix = { config, lib, pkgs, ... }: {
    # Import parent aspect for inheritance
    imports = [ inputs.self.modules.nixos.common-nix ];

    environment.etc."channels/nixpkgs".source = inputs.nixpkgs-stable.outPath;

    nix = {
      registry.nixpkgs.flake = inputs.nixpkgs-stable;
      nixPath = [
        "nixpkgs=/etc/channels/nixpkgs"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    };
  };
}
