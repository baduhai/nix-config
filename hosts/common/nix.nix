{ config, pkgs, lib, ... }:

{
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = { # Garbage collector
      automatic = true;
      options = "--delete-older-than 8d";
    };
  };

  system.stateVersion = "22.05";
}
