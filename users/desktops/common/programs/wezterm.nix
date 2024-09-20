{ config, pkgs, lib, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = # lua
      ''
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
        wezterm.on('update-right-status', function(window, pane)
          -- Each element holds the text for a cell in a "powerline" style << fade
          local cells = {}

          -- Figure out the cwd and host of the current pane.
          -- This will pick up the hostname for the remote host if your
          -- shell is using OSC 7 on the remote host.
          local cwd_uri = pane:get_current_working_dir()
          if cwd_uri then
            local cwd = ""
            local hostname = ""

            cwd = cwd_uri.file_path
            hostname = cwd_uri.host or wezterm.hostname()

            -- Remove the domain name portion of the hostname
            local dot = hostname:find '[.]'
            if dot then
              hostname = hostname:sub(1, dot - 1)
            end
            if hostname == "" then
              hostname = wezterm.hostname()
            end

            table.insert(cells, cwd)
            table.insert(cells, hostname)
          end

          local date = wezterm.strftime '%H:%M'
          table.insert(cells, date)

          -- An entry for each battery (typically 0 or 1 battery)
          for _, b in ipairs(wezterm.battery_info()) do
            table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
          end

          local SOLID_LEFT_ARROW = ''

          -- Color palette for the backgrounds of each cell
          local colors = {
            '${config.lib.stylix.colors.withHashtag.base01}',
            '${config.lib.stylix.colors.withHashtag.base02}',
            '${config.lib.stylix.colors.withHashtag.base03}',
            '${config.lib.stylix.colors.withHashtag.base04}',
            '${config.lib.stylix.colors.withHashtag.base04}',
          }

          -- Foreground color for the text across the fade
          local text_fg = '${config.lib.stylix.colors.withHashtag.base05}'

          -- The elements to be formatted
          local elements = {}
          -- How many cells have been formatted
          local num_cells = 0

          -- Translate a cell into elements
          function push(text, is_last)
            local cell_no = num_cells + 1
            table.insert(elements, { Foreground = { Color = text_fg } })
            table.insert(elements, { Background = { Color = colors[cell_no] } })
            table.insert(elements, { Text = text .. ' ' })
            if not is_last then
              table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
              table.insert(elements, { Text = SOLID_LEFT_ARROW })
            end
            num_cells = num_cells + 1
          end

          while #cells > 0 do
            local cell = table.remove(cells, 1)
            push(cell, #cells == 0)
          end

          window:set_right_status(wezterm.format(elements))
        end)
        return {
          disable_default_key_bindings = true,
          window_padding = {
            left = "2pt",
            right = "2pt",
            bottom = "2pt",
            top = "2pt",
          },
          command_palette_font_size = 12,
          initial_cols = get_initial_cols_by_hostname(),
          initial_rows = 32,
          inactive_pane_hsb = {
            brightness = 0.5,
          },
          hide_tab_bar_if_only_one_tab = false,
          show_new_tab_button_in_tab_bar = false,
          tab_bar_at_bottom = true,
          use_fancy_tab_bar = false,
          front_end = "WebGpu",
          keys = {
            { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
            { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
            { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
            { key = ':', mods = 'SHIFT|CTRL', action = act.SplitVertical{ domain = 'CurrentPaneDomain' } },
            { key = '?', mods = 'SHIFT|CTRL', action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
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
