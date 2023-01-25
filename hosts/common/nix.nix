{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      connect-timeout = 10;
      log-lines = 25;
      min-free = 128000000;
      max-free = 1000000000;
    };
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 8d";
    };
  };

  system.stateVersion = "22.05";
}
