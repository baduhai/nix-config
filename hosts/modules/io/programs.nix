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
  environment = {
    systemPackages = with pkgs; [
      arduino-ide
      esptool
      # fritzing
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
}
