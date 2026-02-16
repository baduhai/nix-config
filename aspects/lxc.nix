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
      virtualisation.lxc = {
        enable = true;
        unprivilegedContainers = true;
      };
    };
}
