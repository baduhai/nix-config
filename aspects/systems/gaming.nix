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
          rec {
            appId = "com.hypixel.HytaleLauncher";
            sha256 = "uu7FA36M4wSqDXRF1fFNla8S5MjL1N1kZi4gwbpw1oY=";
            bundle = "${pkgs.fetchurl {
              url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
              inherit sha256;
            }}";
          }
        ];

        environment.systemPackages = with pkgs; [
          clonehero
          heroic
          prismlauncher
        ];
      };

    # Home-manager side of gaming. MangoHud is deliberately not enabled;
    # import `mangohud` (aspects/gaming/mangohud.nix) if it is ever wanted.
    homeManager.gaming = _: { };
  };
}
