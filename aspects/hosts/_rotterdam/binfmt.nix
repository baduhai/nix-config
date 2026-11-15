{ ... }:

{
  # Run aarch64-linux binaries through qemu-user so this x86_64 host can build
  # aarch64 derivations locally (handy for trantor). NixOS also adds the
  # emulated system to nix's extra-platforms, so `nix build .#pkg` works.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
