{ ... }:

{
  flake.modules = {
    nixos.media =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          mpv
          qview
        ];

        services.flatpak.packages = [
          "com.stremio.Stremio"
          {
            appId = "com.pocoguy.Muse";
            origin = "flatpark";
          }
        ];

        services.flatpak.overrides."com.stremio.Stremio".Environment = {
          DISABLE_MANGOHUD = "1";
        };
      };

    homeManager.media =
      { pkgs, ... }:
      {
        programs.obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            obs-vkcapture
            obs-backgroundremoval
            obs-pipewire-audio-capture
          ];
        };
      };
  };
}
