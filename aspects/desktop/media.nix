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

        # Streaming shell: flatpak instead of pkgs.stremio-linux-shell because the
        # nix build's bundled server only looks for ffmpeg in /usr paths, while the
        # flatpak ships ffmpeg/ffprobe inside the sandbox.
        services.flatpak.packages = [ "com.stremio.Stremio" ];

        # programs.mangohud.enableSessionWide exports MANGOHUD=1, which flatpak
        # forwards into the sandbox and activates the MangoHud Vulkan layer. That
        # layer segfaults inside mpv's hwdec init (vkCreateDevice), taking Stremio
        # down. The layer honours DISABLE_MANGOHUD, so set it for this app only.
        systemd.tmpfiles.rules = [
          "L+ /var/lib/flatpak/overrides/com.stremio.Stremio - - - - ${pkgs.writeText "stremio-flatpak-overrides" ''
            [Environment]
            DISABLE_MANGOHUD=1
          ''}"
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
