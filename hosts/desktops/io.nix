{ config, pkgs, lib, ... }:

let
  cml-ucm-conf = pkgs.alsa-ucm-conf.overrideAttrs {
    wttsrc = pkgs.fetchurl {
      url =
        "https://github.com/WeirdTreeThing/chromebook-ucm-conf/archive/2b2f3a7c993fd38a24aa81394e29ee530b890658.tar.gz";
      hash = "sha256-WeLkxWB174Hwb11xnIxsvRm5NpM528IVEYH4K32pLwg=";
    };
    unpackPhase = ''
      runHook preUnpack
      tar xf "$src"
      tar xf "$wttsrc"
      runHook postUnpack
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/alsa
      cp -r alsa-ucm*/{ucm,ucm2} $out/share/alsa
      cp -r chromebook-ucm*/{common,codecs,platforms} $out/share/alsa/ucm2
      cp -r chromebook-ucm*/{sof-rt5682,sof-cs42l42} $out/share/alsa/ucm2/conf.d
      cp -r chromebook-ucm*/cml/* $out/share/alsa/ucm2/conf.d
      runHook postInstall
    '';
  };
in {
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
    systemPackages = with pkgs; [ maliit-keyboard ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${cml-ucm-conf}/share/alsa/ucm2";
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
}
