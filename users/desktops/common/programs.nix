{ config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 10;
    };
  };

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
        sysrebuild =
          "nh os switch --ask /home/user/Projects/personal/nix-config";
        sysrebuild-boot =
          "nh os boot --ask /home/user/Projects/personal/nix-config";
        sysupdate =
          "nix flake update --commit-lock-file /home/user/Projects/personal/nix-config";
        syscleanup =
          "sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration boot";
        code = ''
          wezterm cli split-pane --top --percent=75 -- hx
          wezterm cli activate-pane-direction up          
        '';
      };
    };
  };
}
