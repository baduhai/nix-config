{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  imports = [
    # Host-common imports
    ../common
    # Desktop-common imports
    ./common
    # Host-specific imports
    ./io
  ];

  networking.hostName = "io";

  nix.nixPath = [ "nixos-config=${./io.nix}" ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  boot = {
    kernelParams = [ "nosgx" "i915.fastboot=1" "mem_sleep_default=deep" ];
    kernelModules = [
      "i2c-dev" # Required for arduino dev
      "i2c-piix4" # Required for arduino dev
    ];
  };

  environment.systemPackages = with pkgs; [
    arduino
    gnome-network-displays
    maliit-keyboard
    rnote
    write_stylus
  ];

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
