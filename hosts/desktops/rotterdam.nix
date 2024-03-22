{ inputs, config, pkgs, lib, ... }:

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

  services = {
    hardware.openrgb.enable = true;
    keyd = {
      enable = true;
      keyboards.main = {
        ids = [ "*" ];
        settings = {
          main = { esc = "overload(meta, esc)"; };
          shift = {
            leftshift = "capslock";
            rightshift = "capslock";
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs;
    [ (ollama.override { acceleration = "rocm"; }) ];

  hardware.opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  systemd.targets.hibernate.enable = false; # disable non-functional hibernate

  nix.nixPath = [ "nixos-config=${./rotterdam.nix}" ];

  # users.users.user.extraGroups = [ "corectrl" ];

  boot.kernelParams = [
    "processor.max_cstate=1" # Fixes bug where ryzen cpus freeze when in highest C state
    "clearcpuid=514"
  ];

  programs = {
    # corectrl.enable = true;
    steam.dedicatedServer.openFirewall = true;
  };
}
