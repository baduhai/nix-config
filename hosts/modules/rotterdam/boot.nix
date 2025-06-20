{ pkgs, ... }:

let
  qubesnsh = pkgs.writeTextFile {
    name = "qubes.nsh";
    text = "HD1f65535a1:EFI\\qubes\\grubx64.efi";
  };
in

{
  boot = {
    kernelParams = [
      "processor.max_cstate=1" # Fixes bug where ryzen cpus freeze when in highest C state
      "clearcpuid=514"
      "amdgpu.ppfeaturemask=0xfffd3fff" # Fixes amdgpu freezing
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
}
