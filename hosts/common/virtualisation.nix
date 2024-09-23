{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
  };

  systemd = {
    services.podman-auto-update.enable = true;
    timers.podman-auto-update.enable = true;
  };
}
