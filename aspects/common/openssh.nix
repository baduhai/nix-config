{ ... }:
{
  flake.modules.nixos.common-openssh =
    { ... }:
    {
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
        extraConfig = ''
          PrintLastLog no
        '';
      };
    };
}
