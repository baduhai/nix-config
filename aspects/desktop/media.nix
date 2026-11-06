{ ... }:

{
  flake.modules = {
    nixos.media =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          mpv
          obs-studio
          qview
        ];

        services.flatpak.packages = [
          "com.stremio.Stremio"
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
