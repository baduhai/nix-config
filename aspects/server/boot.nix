# aspects/server/boot.nix
{ inputs, ... }:
{
  flake.modules.nixos.server-boot = { config, lib, pkgs, ... }: {
    # Import parent aspect for inheritance
    imports = [ inputs.self.modules.nixos.common-boot ];

    boot.kernelPackages = pkgs.linuxPackages_hardened;
  };
}
