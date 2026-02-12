{ ... }:
{
  flake.modules.nixos.common-firewall =
    { ... }:
    {
      networking = {
        firewall.enable = true;
        nftables.enable = true;
      };
    };
}
