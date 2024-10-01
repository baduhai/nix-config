{ ... }:

{
  services.postgresql.enable = true;

  # TODO: remove when bug fux 
  # Workaround for upstream bug in NetworkManager-wait-online.service
  systemd.services.NetworkManager-wait-online.enable = false;
}
