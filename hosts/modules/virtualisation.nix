{
  hostType,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        autoPrune.enable = true;
        extraPackages = [ pkgs.podman-compose ];
      };

      systemd = {
        services.podman-auto-update.enable = true;
        timers.podman-auto-update.enable = true;
      };

    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
      virtualisation = {
        libvirtd.enable = true;
        lxd.enable = true;
      };
    })
  ];
}
