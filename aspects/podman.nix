{ ... }:
{
  flake.modules.nixos.podman =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      virtualisation.podman = {
        enable = true;
        autoPrune.enable = true;
        extraPackages = [ pkgs.podman-compose ];
      };

      security.unprivilegedUsernsClone = true; # Needed for rootless podman

      systemd = {
        services.podman-auto-update.enable = true;
        timers.podman-auto-update.enable = true;
      };
    };
}
