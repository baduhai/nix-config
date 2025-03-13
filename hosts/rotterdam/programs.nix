{ pkgs, ... }:

let
  reboot-into-qubes = pkgs.makeDesktopItem {
    name = "reboot-into-qubes";
    icon = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/vinceliuice/Qogir-icon-theme/31f267e1f5fd4e9596bfd78dfb41a03d3a9f33ee/src/scalable/apps/distributor-logo-qubes.svg";
      sha256 = "sha256-QbHr7s5Wcs7uFtfqZctMyS0iDbMfiiZOKy2nHhDOfn0=";
    };
    desktopName = "Qubes OS";
    genericName = "Reboot into Qubes OS";
    categories = [ "System" ];
    startupNotify = true;
    exec = pkgs.writeShellScript "reboot-into-qubes" ''
      ${pkgs.yad}/bin/yad --form \
                          --title="Qubes OS" \
                          --image distributor-logo-qubes \
                          --text "Are you sure you want to reboot into Qubes OS?" \
                          --button="Yes:0" --button="Cancel:1"
      if [ $? -eq 0 ]; then
        systemctl reboot --boot-loader-entry=qubes.conf
      fi
    '';
  };
in

{
  environment.systemPackages = [ reboot-into-qubes ];

  services.flatpak.packages = [ "net.retrodeck.retrodeck" ];

  programs.steam.dedicatedServer.openFirewall = true;
}
