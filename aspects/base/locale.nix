{ ... }:
{
  flake.modules.nixos.locale =
    { config, ... }:
    {
      time.timeZone = "America/Bahia";

      # Flatpak reads the zone name by stripping $TZDIR from the target of
      # /etc/localtime. User units inherit TZDIR=<tzdata>/share/zoneinfo from
      # systemd.globalEnvironment, which never matches /etc/zoneinfo/<zone>,
      # so flatpak falls back to /etc/timezone (Debian-style) and then to UTC.
      # Creating it keeps sandboxed apps on the system timezone.
      environment.etc."timezone".text = "${config.time.timeZone}\n";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "pt_BR.utf8";
          LC_COLLATE = "pt_BR.utf8";
          LC_IDENTIFICATION = "pt_BR.utf8";
          LC_MEASUREMENT = "pt_BR.utf8";
          LC_MONETARY = "pt_BR.utf8";
          LC_NAME = "pt_BR.utf8";
          LC_NUMERIC = "pt_BR.utf8";
          LC_PAPER = "pt_BR.utf8";
          LC_TELEPHONE = "pt_BR.utf8";
          LC_TIME = "en_IE.utf8";
        };
      };
    };
}
