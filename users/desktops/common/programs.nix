{ config, pkgs, lib, ... }:

{
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
      settings = {
        control = "mangohud";
        legacy_layout = 0;
        text_color = "ffffff";
        ram_color = "ffffff";
        vram_color = "ffffff";
        frametime_color = "ffffff";
        media_player_color = "ffffff";
        io_color = "ffffff";
        engine_color = "ffffff";
        background_alpha = 0;
        offset_y = 4;
        offset_x = 4;
        position = "top-left";
        toggle_hud = "Shift_R+F12";
        horizontal = true;
        time = true;
        time_format = "%H:%M";
        battery_icon = true;
        gamepad_battery_icon = true;
        gpu_stats = true;
        gpu_temp = true;
        gpu_load_change = true;
        gpu_load_value = "50,90";
        gpu_text = "GPU";
        gpu_color = "ffffff";
        gpu_load_color = "FFFFFF,FFAA7F,CC0000";
        cpu_stats = true;
        cpu_temp = true;
        cpu_load_change = true;
        core_load_change = true;
        cpu_load_value = "50,90";
        cpu_text = "CPU";
        cpu_color = "ffffff";
        cpu_load_color = "FFFFFF,FFAA7F,CC0000";
        vram = true;
        ram = true;
        fps = true;
        frame_timing = true;
        table_columns = 20;
        horizontal_stretch = 0;
      };
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
      };
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        function scheme_for_appearance(appearance)
          if appearance:find "Dark" then
            return "Catppuccin Mocha"
          else
            return "Catppuccin Macchiato"
          end
        end
        return {
          font_size = 11,
          color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
          hide_tab_bar_if_only_one_tab = true,
          font = wezterm.font_with_fallback ({
            "Hack Nerd Font",
            "Noto Color Emoji",
          }),
          initial_cols = 108,
          initial_rows = 32,
          enable_tab_bar = false,
          enable_scroll_bar = true,
        }
      '';
    };
  };
}
