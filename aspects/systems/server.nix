{ inputs, ... }:

{
  flake.modules.nixos.server =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_hardened;
        kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
        };
      };

      environment.etc."channels/nixpkgs".source = inputs.nixpkgs-stable.outPath;

      nix = {
        registry.nixpkgs.flake = inputs.nixpkgs-stable;
        nixPath = [
          "nixpkgs=/etc/channels/nixpkgs"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
      };

      services.tailscale = {
        extraSetFlags = [ "--advertise-exit-node" ];
        useRoutingFeatures = "server";
      };

    };
}
