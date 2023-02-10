{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  imports = [
    # Host-common imports
    ../common
    # Desktop-common imports
    ./common
    # Host-specific imports
    ./rotterdam
  ];

  networking.hostName = "rotterdam";

  nix.nixPath = [ "nixos-config=${./rotterdam.nix}" ];

  boot.kernelParams = [
    "processor.max_cstate=1" # Fixes bug where ryzen cpus freeze when in highest C state
  ];

  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    yuzu-ea
  ];

  programs.corectrl.enable = true;

  users.users.user.extraGroups = [
    "corectrl"
  ];
}
