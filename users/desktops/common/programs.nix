{ config, pkgs, lib, ... }:

let
  MangoHudConf = pkgs.writeTextFile {
    name = "MangoHud.conf";
    text = ''
      time
      fps
      gpu_stats
      gpu_temp
      vram
      cpu_stats
      cpu_temp
      ram
      frame_timing
      battery_icon
      gamepad_battery_icon
      #media_player

      horizontal
      horizontal_stretch=0
      legacy_layout=0
      background_alpha=0
      position=top-left
      control=mangohud
      offset_x=4
      offset_y=4
      table_columns=20
      time_format=%H:%M
      toggle_hud=Shift_R+F12
      media_player_format={title} - {artist}
      font_scale_media_player=1

      core_load_change
      cpu_color=ffffff
      cpu_load_change
      cpu_load_color=FFFFFF,FFAA7F,CC0000
      cpu_load_value=50,90
      cpu_text=CPU

      gpu_color=ffffff
      gpu_load_change
      gpu_load_color=FFFFFF,FFAA7F,CC0000
      gpu_load_value=50,90
      gpu_text=GPU

      io_color=ffffff
      media_player_color=ffffff
      ram_color=ffffff
      text_color=ffffff
      vram_color=ffffff
      engine_color=ffffff
      frametime_color=ffffff
    '';
  };

in {
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 10;
    };
    theme = {
      package = pkgs.breeze-gtk;
      name = "Breeze";
    };
    iconTheme = {
      package = pkgs.breeze-icons;
      name = "Breeze";
    };
  };

  programs = {

    password-store.package = pkgs.pass-wayland;

    mangohud = {
      enable = true;
      enableSessionWide = true;
    };

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
        rebuild =
          "sudo nixos-rebuild switch --flake '/home/user/Projects/personal/nix-config#'";
        rebuild-boot =
          "sudo nixos-rebuild boot --flake '/home/user/Projects/personal/nix-config#'";
        update =
          "nix flake update --commit-lock-file /home/user/Projects/personal/nix-config";
        hm-rebuild =
          "rm ~/.gtkrc-2.0; nix run '/home/user/Projects/personal/nix-config#homeConfigurations.desktop.activationPackage'";
        code = ''
          wezterm cli split-pane --top --percent=75 -- hx
          wezterm cli activate-pane-direction up          
        '';
      };
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        local act = wezterm.action
        local config = {}
        if wezterm.config_builder then config = wezterm.config_builder() end
        config.color_scheme = "Catppuccin Mocha"
        config.font = wezterm.font_with_fallback ({
          {family = "Hack Nerd Font", scale = 1},
          {family = "Noto Color Emoji", scale = 1},
        })
        config.initial_cols = 108
        config.initial_rows = 32
        config.enable_scroll_bar = true
        config.inactive_pane_hsb = {
          saturation = 0.7,
          brightness = 0.5
        }
        config.window_frame = {
          font = wezterm.font_with_fallback ({
            {family = "Hack Nerd Font", scale = 1},
            {family = "Noto Color Emoji", scale = 1},
          }),
          active_titlebar_bg = '#303446',
          inactive_titlebar_bg = '#303446',
        }
        config.show_new_tab_button_in_tab_bar = false
        config.colors = {
          tab_bar = {
            background = '#303446',
            active_tab = {
              bg_color = '#1e1e2e',
              fg_color = '#9197b0',
            },
            inactive_tab = {
              bg_color = '#303446',
              fg_color = '#9197b0'
            },
            inactive_tab_edge = '#303062',
          }
        }
        return config
      '';
    };
  };

  home.file.".config/MangoHud/MangoHud.conf".source = MangoHudConf;
}
