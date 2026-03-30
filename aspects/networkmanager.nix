{ ... }:
{
  flake.modules.nixos.networkmanager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      networking.networkmanager.enable = true;

      users.users.user.extraGroups = [ "networkmanager" ];
    };
}
