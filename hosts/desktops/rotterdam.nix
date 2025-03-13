{ pkgs, ... }:

let
  qubesnsh = pkgs.writeTextFile {
    name = "qubes.nsh";
    text = "HD1f65535a1:EFI\\qubes\\grubx64.efi";
  };

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
  imports = [
    # Host-common imports
    ../modules
    # Desktop-common imports
    ./common
    # Host-specific imports
    ./rotterdam
  ];

  networking.hostName = "rotterdam";

  services = {
    flatpak.packages = [ "net.retrodeck.retrodeck" ];
    keyd = {
      enable = true;
      keyboards.main = {
        ids = [ "5653:0001" ];
        settings.main = {
          esc = "overload(meta, esc)";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [ reboot-into-qubes ];

  hardware = {
    amdgpu = {
      opencl.enable = true;
      amdvlk.enable = true;
    };
    graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  systemd.targets.hibernate.enable = false; # disable non-functional hibernate

  nix.nixPath = [ "nixos-config=${./rotterdam.nix}" ];

  boot = {
    kernelParams = [
      "processor.max_cstate=1" # Fixes bug where ryzen cpus freeze when in highest C state
      "clearcpuid=514"
      # Fixes amdgpu freezing
      "amdgpu.noretry=0"
      "amdgpu.ppfeaturemask=0xfffd3fff"
      "amdgpu.gpu_recovery=1"
      "amdgpu.lockup_timeout=1000"
    ];
    # QubesOS boot entry
    loader.systemd-boot = {
      extraFiles = {
        "efi/edk2-shell/shell.efi" = "${pkgs.edk2-uefi-shell}/shell.efi";
        "qubes.nsh" = qubesnsh;
      };
      extraEntries."qubes.conf" = ''
        title Qubes OS
        efi /efi/edk2-shell/shell.efi
        options -nointerrupt qubes.nsh
        sort-key ab
      '';
    };
  };

  programs.steam.dedicatedServer.openFirewall = true;
}
