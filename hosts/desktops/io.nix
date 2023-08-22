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

  services.keyd = {
    enable = true;
    keyboards.main = {
      ids = [ "0001:0001" ];
      settings = {
        main = {
          meta = "overload(meta, esc)";
          f1 = "back";
          f2 = "forward";
          f3 = "refresh";
          f4 = "M-f11";
          f5 = "M-w";
          f6 = "brightnessdown";
          f7 = "brightnessup";
          f8 = "timeout(mute, 200, micmute)";
          f9 = "play";
          f10 = "timeout(nextsong, 200, previoussong)";
          f13 = "delete";
          "102nd" = "layer(function)";
        };
        shift = {
          leftshift = "capslock";
          rightshift = "capslock";
        };
        function = {
          escape = "f1";
          f1 = "f2";
          f2 = "f3";
          f3 = "f4";
          f4 = "f5";
          f5 = "f6";
          f6 = "f7";
          f7 = "f8";
          f8 = "f9";
          f9 = "f10";
          f10 = "f11";
          f13 = "f12";
          u = "sysrq";
          k = "home";
          l = "pageup";
          "," = "end";
          "." = "pagedown";
        };
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
