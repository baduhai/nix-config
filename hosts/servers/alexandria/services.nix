{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  services.postgresql.enable = true;

  # Workaround for upstream bug in NetworkManager-wait-online.service
  systemd.services.NetworkManager-wait-online.enable = false;
}
