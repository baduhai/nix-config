{ ... }:

{
  services.postgresql.enable = true;

  # TODO: remove when bug fix
  # serokell/deploy-rs/issues/57
  # NixOS/nixpkgs/issues/180175
  # Workaround for upstream bug in NetworkManager-wait-online.service
  systemd.services.NetworkManager-wait-online.enable = false;
}
