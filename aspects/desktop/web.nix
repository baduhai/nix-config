{ ... }:

{
  flake.modules.nixos.web =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nextcloud-client
        transmission_4-gtk
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
