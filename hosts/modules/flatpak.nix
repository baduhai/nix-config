{
  hostType,
  lib,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
      services.flatpak = {
        enable = true;
        packages = [
          "com.github.k4zmu2a.spacecadetpinball"
          "com.github.tchx84.Flatseal"
          "com.steamgriddb.SGDBoop"
          "app.zen_browser.zen"
          "io.github.Foldex.AdwSteamGtk"
          "io.itch.itch"
          "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
        ];
        uninstallUnmanaged = true;
        update.auto.enable = true;
      };
    })
  ];
}
