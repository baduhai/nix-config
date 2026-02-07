# aspects/server/tailscale.nix
{ inputs, ... }:
{
  flake.modules.nixos.server-tailscale = { config, lib, pkgs, ... }: {
    # Import parent aspect for inheritance
    imports = [ inputs.self.modules.nixos.common-tailscale ];

    services.tailscale = {
      extraSetFlags = [ "--advertise-exit-node" ];
      useRoutingFeatures = "server";
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };
}
