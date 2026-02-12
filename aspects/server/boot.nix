# aspects/server/boot.nix
{ ... }:
{
  flake.modules.nixos.server-boot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      boot.kernelPackages = pkgs.linuxPackages_hardened;
    };
}
