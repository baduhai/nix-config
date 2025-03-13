{ hostType, lib, ... }:

{
  config = lib.mkMerge [
    # Common configuration
    {
      security = {
        unprivilegedUsernsClone = true; # Needed for rootless podman
        sudo = {
          wheelNeedsPassword = false;
          extraConfig = ''
            Defaults lecture = never
          '';
        };
      };
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
    })
  ];
}
