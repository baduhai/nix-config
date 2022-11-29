{ config, pkgs, lib, ... }:

{
  imports = [ 
    # Host-specific imports
    ./io/hardware-configuration.nix
    # Host-common imports
    ../../common/networking.nix
    ../../common/services.nix
    ../../common/packages.nix
    ../../common/locale.nix
    ../../common/users.nix
    ../../common/boot.nix
    ../../common/nix.nix
    # Desktop-common imports
    ../common/virtualisation.nix
    ../common/hardware.nix
    ../common/services.nix
    ../common/packages.nix
    ../common/users.nix
    ../common/boot.nix
  ];

  networking.hostName = "io";

  environment.systemPackages = with pkgs; [
    gnome-network-displays
    maliit-keyboard
    rnote
    write_stylus
  ];

  boot.kernelParams = [
    "nosgx"
    "i915.fastboot=1"
    "mem_sleep_default=deep"
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  services = {
    kmonad = {
      enable = true;
      keyboards.internal = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = builtins.readFile ./io/kmonad.kbd;
      };
    };
  };
}
