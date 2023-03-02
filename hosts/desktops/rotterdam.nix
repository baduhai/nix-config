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

  services.hardware.openrgb.enable = true;

  systemd.targets.hibernate.enable = false; # disable non-functional hibernate

  nix.nixPath = [
    "nixos-config=${./rotterdam.nix}"
  ];

  users.users.user.extraGroups = [
    "corectrl"
  ];

  boot.kernelParams = [
    "processor.max_cstate=1" # Fixes bug where ryzen cpus freeze when in highest C state
  ];

  environment.sessionVariables = rec {
    KWIN_DRM_NO_AMS = "1"; # RDNA2 colour/gamma modesetting bug workaround for kwin wayland
  };

  programs = {
    corectrl.enable = true;
    steam.dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    cemu
#     retroarchFull
    rpcs3
    yuzu-ea
    # Packages from 3rd party overlays
    emulationstation-de
  ];

  networking.firewall = {
    allowedTCPPorts =[
      27036 # Steam remote play
      27037 # Steam remote play
    ];
    allowedUDPPorts =[
      27031 # Steam remote play
      27036 # Steam remote play
    ];
  };
}
