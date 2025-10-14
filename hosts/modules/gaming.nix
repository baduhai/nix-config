{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    clonehero
    heroic
    mangohud
    prismlauncher
    protonup
    steam-run
  ];

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode.enable = true;
  };

  hardware = {
    xpadneo.enable = true;
    steam-hardware.enable = true; # Allow steam client to manage controllers
    graphics.enable32Bit = true; # For OpenGL games
  };

  services.flatpak.packages = [
    "com.github.k4zmu2a.spacecadetpinball"
    "com.steamgriddb.SGDBoop"
    "io.github.Foldex.AdwSteamGtk"
    "io.itch.itch"
    "io.mrarm.mcpelauncher"
    "net.retrodeck.retrodeck"
    "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
  ];
}
