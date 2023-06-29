{ inputs, config, pkgs, lib, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune = true;
  };
}
