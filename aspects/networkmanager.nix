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
      networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };

      users.users.user.extraGroups = [ "networkmanager" ];
    };
}
