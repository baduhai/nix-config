{ ... }:
{
  flake.modules.nixos.fwupd =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.fwupd.enable = true;
    };
}
