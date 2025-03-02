{ pkgs, ... }:

let
  cml-ucm-conf = pkgs.alsa-ucm-conf.overrideAttrs {
    wttsrc = pkgs.fetchFromGitHub {
      owner = "WeirdTreeThing";
      repo = "chromebook-ucm-conf";
      rev = "b6ce2a7";
      hash = "sha256-QRUKHd3RQmg1tnZU8KCW0AmDtfw/daOJ/H3XU5qWTCc=";
    };
    postInstall = ''
      echo "v0.4.1" > $out/chromebook.patched
      cp -R $wttsrc/{common,codecs,platforms} $out/share/alsa/ucm2
      cp -R $wttsrc/{cml,sof-rt5682} $out/share/alsa/ucm2/conf.d
    '';
  };
in
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
    # TODO check if future kernel versions fix boot issue with systemd initrd with tpm
    initrd.systemd.tpm2.enable = false;
    kernelParams = [
      "nosgx"
      "i915.fastboot=1"
      "mem_sleep_default=deep"
    ];
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=3
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      maliit-keyboard
      sof-firmware
    ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${cml-ucm-conf}/share/alsa/ucm2";
  };

  # TODO: remove once gmodena/nix-flatpak/issues/45 fixed
  systemd.services."flatpak-managed-install" = {
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
    };
  };

  services = {
    keyd = {
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
            y = "sysrq";
            k = "home";
            l = "pageup";
            "," = "end";
            "." = "pagedown";
          };
        };
      };
    };
  };
}
