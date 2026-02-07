{ inputs, ... }:
{
  flake.modules.nixos.desktop-nix = { config, lib, pkgs, ... }: {
    # Import parent aspect for inheritance
    imports = [ inputs.self.modules.nixos.common-nix ];

    environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

    nix = {
      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    };
  };
}
