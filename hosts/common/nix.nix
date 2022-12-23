{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  nix = {
    settings.auto-optimise-store = true;
    extraOptions = "experimental-features = nix-command flakes";
    gc = { # Garbage collector
      automatic = true;
      options = "--delete-older-than 8d";
    };
  };

  system.stateVersion = "22.05";
}
