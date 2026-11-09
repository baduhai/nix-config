{ ... }:

{
  flake.modules.nixos.web =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qbittorrent
        nextcloud-client
        vesktop
      ];

      services.flatpak.packages = [
        "app.zen_browser.zen"
        {
          appId = "net.imput.helium";
          origin = "flatpark";
        }
        {
          appId = "rocks.zapfast.ZapFast";
          origin = "flatpark";
        }
      ];
    };
}
