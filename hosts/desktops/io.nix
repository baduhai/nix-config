{ inputs, config, pkgs, lib, ... }:

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

  nixpkgs.overlays = with pkgs;
    [
      (final: prev: {
        alsa-ucm-conf = prev.alsa-ucm-conf.overrideAttrs (old: {
          srcs = [
            (fetchurl {
              url = "mirror://alsa/lib/alsa-ucm-conf-1.2.9.tar.bz2";
              hash = "sha256-N09oM7/XfQpGdeSqK/t53v6FDlpGpdRUKkWWL0ueJyo=";
            })
            (fetchurl {
              url =
                "https://github.com/WeirdTreeThing/chromebook-ucm-conf/archive/refs/heads/main.tar.gz";
              hash = "sha256-vXFixh2HZD5zs0wARxAHmwtvk1R8/7gBs2y+delCnGc=";
            })
          ];
          unpackPhase = ''
            runHook preUnpacl
            for _src in $srcs; do
              tar xf "$_src"
            done
            runHook postUnpack
          '';
          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/alsa
            cp -r alsa-ucm-conf-1.2.9/ucm alsa-ucm-conf-1.2.9/ucm2 $out/share/alsa
            mkdir -p $out/share/alsa/ucm2/conf.d
            cp -r chromebook-ucm-conf-main/hdmi-common chromebook-ucm-conf-main/dmic-common chromebook-ucm-conf-main/tgl/* $out/share/alsa/ucm2/conf.d
            runHook postInstall
          '';
        });
      })
    ];
}
