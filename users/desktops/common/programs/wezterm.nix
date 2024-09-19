{ config, pkgs, lib, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
        local act = wezterm.action
        local function get_initial_cols_by_hostname()
          local hostname = wezterm.hostname()
          if hostname == "rotterdam" then
            return 111
          elseif hostname == "io" then
            return 93
          else
            return 100
          end
        end
        return {
        disable_default_key_bindings = true,
        window_padding = {
          left = "2pt",
          right = "2pt",
          bottom = 0,
          top = 0,
        },
        use_fancy_tab_bar = true,
        command_palette_font_size = 12,
        initial_cols = get_initial_cols_by_hostname(),
        initial_rows = 32,
        inactive_pane_hsb = {
          saturation = 0.7,
          brightness = 0.5
        },
        hide_tab_bar_if_only_one_tab = false,
        show_new_tab_button_in_tab_bar = true,
        front_end = "WebGpu",
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
