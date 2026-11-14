{ inputs, ... }:

{
  flake.modules = {
    nixos.gaming =
      { pkgs, ... }:
      {
        imports = with inputs.self.modules.nixos; [
          steam
        ];
        hardware = {
          xpadneo.enable = true;
          steam-hardware.enable = true; # Allow steam client to manage controllers
          graphics.enable32Bit = true; # For OpenGL games
        };

        services.flatpak.packages = [
          "com.github.k4zmu2a.spacecadetpinball"
          "io.itch.itch"
          "io.mrarm.mcpelauncher"
          "net.retrodeck.retrodeck"
          {
            appId = "dev.playhorizon.Horizon";
            origin = "flatpark";
          }
        ];

        environment.systemPackages = with pkgs; [
          clonehero
          heroic
        ];
      };

    # Home-manager side of gaming. MangoHud is deliberately not enabled;
    # import `mangohud` (aspects/gaming/mangohud.nix) if it is ever wanted.
    homeManager.gaming = _: { };
  };
}
