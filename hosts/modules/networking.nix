{
  hostType,
  inputs,
  lib,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      networking = {
        networkmanager.enable = true;
        firewall.enable = true;
      };

      services = {
        tailscale = {
          enable = true;
          extraUpFlags = [ "--operator=user" ];
        };
        openssh.enable = true;
      };
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
      services.tailscale = {
        extraSetFlags = [ "--advertise-exit-node" ];
        useRoutingFeatures = "server";
      };
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
      services = {
        tailscale.useRoutingFeatures = "client";
        nginx = {
          enable = true;
          virtualHosts."localhost".root = inputs.homepage;
        };
      };
    })
  ];
}
