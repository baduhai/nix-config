{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  programs = {
    password-store.package = pkgs.pass-wayland;

    mangohud.enable = true;

    obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.obs-vkcapture
        pkgs.obs-studio-plugins.obs-backgroundremoval
        pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };

    fish = {
      functions = {
        sysrebuild = "nh os switch --ask";
        sysrebuild-boot = "nh os boot --ask";
        sysupdate = "nix flake update --commit-lock-file --flake /home/user/Projects/personal/nix-config";
      };
    };
  };

  gtk = {
    gtk3.extraConfig = {
      gtk-decoration-layout = "appmenu:none";
    };
    gtk4.extraConfig = {
      gtk-decoration-layout = "appmenu:none";
    };
  };
}
