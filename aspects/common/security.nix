{ ... }:
{
  flake.modules.nixos.common-security =
    { ... }:
    {
      security.sudo = {
        wheelNeedsPassword = false;
        extraConfig = ''
          Defaults lecture = never
        '';
      };
    };
}
