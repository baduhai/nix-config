{ hostType, lib, ... }:

{
  config = lib.mkMerge [
    # Common configuration
    {
      time.timeZone = "America/Bahia";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "pt_BR.utf8";
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
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
    })
  ];
}
