{ inputs, ... }:
let
  utils = import ./utils.nix { inherit inputs; };
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
