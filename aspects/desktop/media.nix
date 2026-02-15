{ ... }:

{
  flake.modules = {
    nixos.media =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          decibels
          loupe
          obs-studio
          showtime
        ];
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
