# aspects/server/tailscale.nix
{ ... }:
{
  flake.modules.nixos.server-tailscale =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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
