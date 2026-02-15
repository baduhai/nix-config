{ ... }:
{
  flake.modules.nixos.security =
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
