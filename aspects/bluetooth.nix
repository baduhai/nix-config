{ ... }:
{
  flake.modules.nixos.bluetooth =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
    };
}
