{ inputs, config, pkgs, lib, ... }:

let
  qubesnsh = pkgs.writeTextFile {
    name = "qubes.nsh";
    text = "HD1f65535a1:EFI\\qubes\\grubx64.efi";
  };
in {
  imports = [
    # Host-common imports
    ../common
    # Desktop-common imports
    ./common
    # Host-specific imports
    ./rotterdam
  ];

  networking.hostName = "rotterdam";

  services = {
    hardware.openrgb.enable = true;
    keyd = {
      enable = true;
      keyboards.main = {
        ids = [ "*" ];
        settings = {
          main = { esc = "overload(meta, esc)"; };
          shift = {
            leftshift = "capslock";
            rightshift = "capslock";
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [ ollama ];

  hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  systemd.targets.hibernate.enable = false; # disable non-functional hibernate

  nix.nixPath = [ "nixos-config=${./rotterdam.nix}" ];

  boot = {
    kernelParams = [
      "processor.max_cstate=1" # Fixes bug where ryzen cpus freeze when in highest C state
      "clearcpuid=514"
      "amdgpu.noretry=0"
      "amdgpu.ppfeaturemask=0xfffd3fff"
      "amdgpu.gpu_recovery=1"
      "amdgpu.lockup_timeout=1000"
    ];
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
