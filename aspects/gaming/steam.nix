{ ... }:

{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        steam-run
      ];

      programs = {
        steam = {
          enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
        };
        gamemode.enable = true;
      };

      services.flatpak.packages = [
        "com.steamgriddb.SGDBoop"
        "io.github.Foldex.AdwSteamGtk"
      ];
    };
}
