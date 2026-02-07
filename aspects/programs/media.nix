{ ... }:

{
  flake.modules = {
    nixos.programs-media = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        # Audio
        decibels
        # Video
        showtime
        # Image Viewer
        loupe
        # Recording & Streaming
        obs-studio
      ];
    };

    homeManager.programs-media = { pkgs, ... }: {
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
