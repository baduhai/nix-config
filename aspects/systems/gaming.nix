{ inputs, ... }:

{
  flake.modules = {
    nixos.gaming =
      { pkgs, ... }:
      {
        imports = with inputs.self.modules.nixos; [
          mangohud
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
          "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
          rec {
            appId = "com.hypixel.HytaleLauncher";
            sha256 = "01307s44bklc1ldcigcn9n4lm8hf8q793v9fv7w4w04xd5zyh4rv";
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
    homeManager.gaming =
      { ... }:
      {
        imports = with inputs.self.modules.homeManager; [
          mangohud
        ];
      };
  };
}
