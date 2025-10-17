{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;
  utils = import ./utils.nix { inherit inputs lib; };
  inherit (utils) mkHome;
in

{
  flake.homeConfigurations = {
    "user@rotterdam" = mkHome {
      username = "user";
      tags = [
        "btop"
        "desktop"
        "direnv"
        "gaming"
        "helix"
        "obs-studio"
        "starship"
        "stylix"
        "tmux"
      ];
    };

    "user@io" = mkHome {
      username = "user";
      tags = [
        "btop"
        "desktop"
        "direnv"
        "helix"
        "starship"
        "stylix"
        "tmux"
      ];
    };
  };
}
