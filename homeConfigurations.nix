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
      hostname = "rotterdam";
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
      hostname = "io";
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
