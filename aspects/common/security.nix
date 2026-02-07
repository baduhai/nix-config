{ ... }:
{
  flake.modules.nixos.common-security = { ... }: {
    security = {
      unprivilegedUsernsClone = true; # Needed for rootless podman
      sudo = {
        wheelNeedsPassword = false;
        extraConfig = ''
          Defaults lecture = never
        '';
      };
    };
  };
}
