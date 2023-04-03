{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services = { kdeconnect.enable = true; };
}
