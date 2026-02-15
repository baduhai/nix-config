{ ... }:
{
  flake.modules.nixos.firewall =
    { ... }:
    {
      networking = {
        firewall.enable = true;
        nftables.enable = true;
      };
    };
}
