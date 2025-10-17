{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;
  utils = import ./utils.nix { inherit inputs lib; };
  inherit (utils) mkUser;
in

{
  flake.homeConfigurations = {
    "user@rotterdam" = mkUser {
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

    "user@io" = mkUser {
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
