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
