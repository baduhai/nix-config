{ config, pkgs, lib, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
        local act = wezterm.action

        local function get_initial_cols_by_hostname()
          local hostname = wezterm.hostname()

          if hostname == "rotterdam" then
            return 110
          elseif hostname == "io" then
            return 89
          else
            return 108
          end
        end

        return {
        disable_default_key_bindings = true,
        color_scheme = "Catppuccin Mocha",
        font = wezterm.font_with_fallback ({
          {family = "Hack Nerd Font", scale = 1},
          {family = "Noto Color Emoji", scale = 1},
        }),
        initial_cols = get_initial_cols_by_hostname(),
        initial_rows = 32,
        enable_scroll_bar = true,
        inactive_pane_hsb = {
          saturation = 0.7,
          brightness = 0.5
        },
        window_frame = {
          font = wezterm.font_with_fallback ({
            {family = "Hack Nerd Font", scale = 1},
            {family = "Noto Color Emoji", scale = 1},
          }),
          active_titlebar_bg = '#303446',
          inactive_titlebar_bg = '#303446',
        },
        hide_tab_bar_if_only_one_tab = true,
        show_new_tab_button_in_tab_bar = false,
        front_end = "WebGpu",
        colors = {
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
          },
        },
        keys = {
          { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
          { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
          { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
          { key = ':', mods = 'SHIFT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
          { key = '?', mods = 'SHIFT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
          { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
          { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
          { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
          { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
          { key = '0', mods = 'CTRL', action = act.ResetFontSize },
          { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
          { key = 'F', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
          { key = 'B', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
          { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
          { key = 'T', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
          { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
          { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
          { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
          { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
          { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
          { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
          { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
          { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
          { key = 'H', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
          { key = 'L', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
          { key = 'K', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Up' },
          { key = 'J', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Down' },
          { key = 'P', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
        },
      }
    '';
  };
}
