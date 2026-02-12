{ ... }:
{
  flake.modules.nixos.common-tailscale =
    { ... }:
    {
      services.tailscale = {
        enable = true;
        extraUpFlags = [ "--operator=user" ];
      };
    };
}
