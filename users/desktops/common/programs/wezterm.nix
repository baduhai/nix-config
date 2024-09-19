{ config, pkgs, lib, ... }:

let
  tabbar-background = config.lib.stylix.colors.withHashtag.base01;
  active-tab-background = config.lib.stylix.colors.withHashtag.base00;
  foreground = config.lib.stylix.colors.withHashtag.base05;
in {
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
                return 110
              end
            end
            return {
            disable_default_key_bindings = true,
            window_padding = {
              left = 0,
              right = 0,
              bottom = 0,
              top = 0,
            },
            colors = {
              tab_bar = {
                background = '${tabbar-background}',
                active_tab = { bg_color = '${active-tab-background}', fg_color = '${foreground}', },
                inactive_tab = { bg_color = '${tabbar-background}', fg_color = '${foreground}', },
                inactive_tab_edge = '${tabbar-background}',
                new_tab = { bg_color = '${tabbar-background}', fg_color = '${foreground}', },
      	      new_tab_hover = { bg_color = '${foreground}', fg_color = '${tabbar-background}', },
              },
            },
            window_frame = {
              active_titlebar_bg = '${tabbar-background}',
              inactive_titlebar_bg = '${tabbar-background}',
            },
            use_fancy_tab_bar = true,
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
