{ config, pkgs, lib, ... }:

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
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=3
    '';
  };

  environment = {
    systemPackages = with pkgs; [ alsa-ucm-conf maliit-keyboard ];
    sessionVariables = {
      ALSA_CONFIG_UCM2 = "${pkgs.alsa-ucm-conf}/share/alsa/ucm2";
    };
  };
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

  # nixpkgs.overlays = with pkgs;
  #   [
  #     (final: prev: {
  #       alsa-ucm-conf = prev.alsa-ucm-conf.overrideAttrs (old: {
  #         wttsrc = (fetchFromGitHub {
  #           owner = "WeirdTreeThing";
  #           repo = "chromebook-ucm-conf";
  #           rev = "484f5c581ac45c4ee6cfaf62bdecedfa44353424";
  #           hash = "sha256-Jal+VfxrPSAPg9ZR+e3QCy4jgSWT4sSShxICKTGJvAI=";
  #         });

  #         installPhase = ''
  #           runHook preInstall
  #           mkdir -p $out/share/alsa
  #           cp -r ucm ucm2 $out/share/alsa
  #           mkdir -p $out/share/alsa/ucm2/conf.d
  #           cp -r $wttsrc/{hdmi,dmic}-common $wttsrc/tgl/* $out/share/alsa/ucm2/conf.d
  #           runHook postInstall
  #         '';
  #       });
  #     })
  #   ];
}
