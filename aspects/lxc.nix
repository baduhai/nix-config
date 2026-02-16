{ ... }:

{
  flake.modules.nixos.lxc =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      virtualisation = {
        lxc = {
          enable = true;
          unprivilegedContainers = true;
        };
        incus.enable = true;
      };

      users.users.user.extraGroups = [ "incus-admin" ];
    };
}
