{ ... }:

{
  flake.modules = {
    nixos.hyprland =
      { lib, pkgs, ... }:
      {
        programs.hyprland.enable = true;

        services.greetd = {
          enable = true;
          settings = {
            initial_session = {
              command = "${pkgs.runtimeShell} -l -c '${lib.getExe pkgs.hyprland}'";
              user = "user";
            };
            default_session = {
              command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
            };
          };
        };

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
          wireplumber.enable = true;
        };

        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
            kdePackages.xdg-desktop-portal-kde
          ];
        };
      };

    homeManager.hyprland =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          alacritty
          awww
          brightnessctl
          swww
          wayle
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          configType = "lua";
          extraConfig = ''
            -- hyprland.lua

            local mod = "SUPER"
            local terminal = "alacritty"
            local menu = "vicinae toggle"
            local frame = 1000 / 60

            -- ============= MONITOR =============
            hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

            -- ============= GENERAL =============
            hl.config({
              general = {
                gaps_in = 5,
                gaps_out = 5,
                border_size = 2,
                resize_on_border = true,
                allow_tearing = false,
                layout = "scrolling",
                col = { active_border = "0xee337733" },
              },
            })

            -- =========== SCROLLING ===========
            local function apply_scrolling_config()
              local m = hl.get_active_monitor()
              if m and m.description and m.description:find("YDU") then
                hl.config({ scrolling = {
                  column_width = 0.333,
                  follow_focus = true,
                  direction = "right",
                  fullscreen_on_one_column = false,
                  explicit_column_widths = "0.333, 0.5, 0.667",
                }})
              else
                hl.config({ scrolling = {
                  column_width = 0.5,
                  follow_focus = true,
                  direction = "right",
                  fullscreen_on_one_column = false,
                  explicit_column_widths = "0.5, 1.0",
                }})
              end
            end
            apply_scrolling_config()
            hl.on("hyprland.start", apply_scrolling_config)
            hl.on("config.reloaded", apply_scrolling_config)
            hl.on("monitor.layout_changed", function()
              hl.timer(apply_scrolling_config, { timeout = frame, type = "oneshot" })
            end)

            -- =========== DECORATION ===========
            hl.config({
              decoration = {
                rounding = 14,
                rounding_power = 2.0,
                dim_inactive = true,
                dim_strength = 0.3,
                shadow = { enabled = true, range = 4, render_power = 3 },
                blur = { enabled = true, size = 8, passes = 1, vibrancy = 0.1696, ignore_opacity = true },
              },
            })

            -- ========== GROUPBAR & BORDERS ==========
            hl.config({
              group = {
                col = {
                  border_active = "0xee337733",
                  border_locked_active = "0xee337733",
                },
                groupbar = {
                  height = 22,
                  indicator_height = 0,
                  indicator_gap = 3,
                  font_size = 13,
                  keep_upper_gap = false,
                  gradient_rounding = 14,
                  gradients = true,
                  col = {
                    active = { colors = { "rgba(337733ff)" } },
                    inactive = { colors = { "rgba(333333ff)" } },
                    locked_active = { colors = { "rgba(337733ff)" } },
                    locked_inactive = { colors = { "rgba(333333ff)" } },
                  },
                },
              },
            })

            -- ============ MISC & SILENCE ============
            hl.config({
              misc = {
                force_default_wallpaper = 2,
                disable_hyprland_logo = true,
                background_color = "0x111111",
              },
              ecosystem = {
                no_update_news = true,
                no_donation_nag = true,
              },
              debug = {
                suppress_errors = true,
              },
            })

            -- ============= INPUT ==============
            hl.config({
              input = {
                kb_layout = "us",
                kb_variant = "altgr-intl",
                follow_mouse = 1,
                sensitivity = 0.0,
                accel_profile = "flat",
                natural_scroll = true,
                touchpad = {
                  natural_scroll = true,
                  clickfinger_behavior = true,
                },
              },
            })

            -- ============ ANIMATIONS ============
            hl.config({ animations = { enabled = true } })

            hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
            hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
            hl.curve("linear",         { type = "bezier", points = { {0, 0},        {1, 1}       } })
            hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0}  } })
            hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

            hl.animation({ leaf = "global",          enabled = true, speed = 0.8, bezier = "default" })
            hl.animation({ leaf = "border",          enabled = true, speed = 0.8, bezier = "easeOutQuint" })
            hl.animation({ leaf = "windows",         enabled = true, speed = 0.8, bezier = "easeOutQuint" })
            hl.animation({ leaf = "windowsIn",       enabled = true, speed = 0.3, bezier = "quick",       style = "popin 95%" })
            hl.animation({ leaf = "windowsOut",      enabled = true, speed = 0.8, bezier = "linear",       style = "popin 87%" })
            hl.animation({ leaf = "fadeIn",          enabled = true, speed = 0.8, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeOut",         enabled = true, speed = 0.8, bezier = "almostLinear" })
            hl.animation({ leaf = "fade",            enabled = true, speed = 0.8, bezier = "quick" })
            hl.animation({ leaf = "layers",          enabled = true, speed = 0.8, bezier = "easeOutQuint" })
            hl.animation({ leaf = "layersIn",        enabled = true, speed = 0.8, bezier = "easeOutQuint", style = "fade" })
            hl.animation({ leaf = "layersOut",       enabled = true, speed = 0.8, bezier = "linear",       style = "fade" })
            hl.animation({ leaf = "fadeLayersIn",    enabled = true, speed = 0.8, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeLayersOut",   enabled = true, speed = 0.8, bezier = "almostLinear" })
            hl.animation({ leaf = "workspaces",      enabled = true, speed = 0.8, bezier = "almostLinear", style = "slidevert" })

            -- =========== AUTOSTART & EVENTS ============
            hl.on("hyprland.start", function()
              hl.exec_cmd("wayle shell")
              hl.dispatch(hl.dsp.focus({ workspace = 50 }))
            end)

            hl.on("window.close", function()
              hl.timer(function()
                local curr = hl.get_active_window()
                if curr and curr.group and curr.group.size <= 1 then
                  hl.dispatch(hl.dsp.group.toggle())
                end
              end, { timeout = frame, type = "oneshot" })
            end)

            -- tabbing: lock group after new alacritty opens
            local pending_lock = false
            hl.on("window.open", function(w)
              if pending_lock and w.class == "Alacritty" then
                hl.timer(function()
                  hl.dispatch(hl.dsp.group.lock({ action = "enable" }))
                end, { timeout = frame, type = "oneshot" })
                pending_lock = false
              end
              -- zen 100% width on non-YDU monitors
              if w.class == "zen-beta" then
                local m = w.monitor
                if m and m.description and not m.description:find("YDU") then
                  hl.timer(function()
                    hl.dispatch(hl.dsp.layout("colresize 1.0"))
                  end, { timeout = frame, type = "oneshot" })
                end
              end
            end)

            -- =========== KEYBINDINGS ============

            -- apps
            hl.bind("ALT + SPACE",              hl.dsp.exec_cmd(menu))
            hl.bind(mod .. " + RETURN",         hl.dsp.exec_cmd(terminal))
            hl.bind(mod .. " + V",              hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))

            -- session
            hl.bind("CTRL + ALT + DELETE",      hl.dsp.exit())

            -- audio & media (wayle)
            hl.bind("XF86AudioRaiseVolume",     hl.dsp.exec_cmd("wayle audio output-volume +5"), { locked = true })
            hl.bind("XF86AudioLowerVolume",     hl.dsp.exec_cmd("wayle audio output-volume -5"), { locked = true })
            hl.bind("XF86AudioMute",            hl.dsp.exec_cmd("wayle audio output-mute"),      { locked = true })
            hl.bind("XF86AudioMicMute",         hl.dsp.exec_cmd("wayle audio input-mute"),       { locked = true })
            hl.bind("XF86AudioNext",            hl.dsp.exec_cmd("wayle media next"),              { locked = true })
            hl.bind("XF86AudioPrev",            hl.dsp.exec_cmd("wayle media previous"),          { locked = true })
            hl.bind("XF86AudioPlay",            hl.dsp.exec_cmd("wayle media play-pause"),        { locked = true })

            -- brightness
            hl.bind("XF86MonBrightnessUp",      hl.dsp.exec_cmd("brightnessctl set +5%"),         { locked = true })
            hl.bind("XF86MonBrightnessDown",    hl.dsp.exec_cmd("brightnessctl set 5%-"),         { locked = true })

            -- window
            hl.bind("ALT + Q", function()
              local curr = hl.get_active_window()
              if curr and curr.group then
                local count = curr.group.size
                local function close_n(n)
                  if n <= 0 then return end
                  local c = hl.get_active_window()
                  if c then hl.dispatch(hl.dsp.window.close()) end
                  hl.timer(function() close_n(n - 1) end, { timeout = frame, type = "oneshot" })
                end
                close_n(count)
              else
                hl.dispatch(hl.dsp.window.kill())
              end
            end)
            hl.bind("ALT + F4", function()
              local curr = hl.get_active_window()
              if curr and curr.group then
                local count = curr.group.size
                local function close_n(n)
                  if n <= 0 then return end
                  local c = hl.get_active_window()
                  if c then hl.dispatch(hl.dsp.window.close()) end
                  hl.timer(function() close_n(n - 1) end, { timeout = frame, type = "oneshot" })
                end
                close_n(count)
              else
                hl.dispatch(hl.dsp.window.kill())
              end
            end)
            hl.bind(mod .. " + SPACE",          hl.dsp.window.float({ action = "toggle" }))
            hl.bind(mod .. " + F",              hl.dsp.layout("colresize 1.0"))
            hl.bind(mod .. " + CTRL + F",       hl.dsp.window.fullscreen({ action = "toggle" }))
            hl.bind(mod .. " + r",              hl.dsp.layout("colresize +conf"))
            hl.bind(mod .. " + CTRL + r",       hl.dsp.layout("colresize -conf"))

            hl.bind(mod .. " + mouse:272",      hl.dsp.window.drag(),   { mouse = true })
            hl.bind(mod .. " + mouse:273",      hl.dsp.window.resize(), { mouse = true })

            -- tabbing
            hl.bind("CTRL + SHIFT + T", function()
              local curr = hl.get_active_window()
              if curr and curr.class == "Alacritty" then
                if not curr.group then hl.dispatch(hl.dsp.group.toggle()) end
                hl.dispatch(hl.dsp.group.lock({ action = "disable" }))
                hl.exec_cmd("alacritty")
                pending_lock = true
              else
                hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "T", window = curr }))
              end
            end)
            hl.bind("CTRL + SHIFT + W", function()
              local curr = hl.get_active_window()
              if curr and curr.group then
                hl.dispatch(hl.dsp.window.close())
              else
                hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "W", window = curr }))
              end
            end)
            hl.bind("CTRL + TAB", function()
              local curr = hl.get_active_window()
              if curr and curr.class == "Alacritty" and curr.group then
                hl.dispatch(hl.dsp.group.next())
              else
                hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL", key = "Tab", window = curr }))
              end
            end)
            hl.bind("CTRL + SHIFT + TAB", function()
              local curr = hl.get_active_window()
              if curr and curr.class == "Alacritty" and curr.group then
                hl.dispatch(hl.dsp.group.prev())
              else
                hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "Tab", window = curr }))
              end
            end)

            -- focus
            hl.bind(mod .. " + h",  hl.dsp.focus({ direction = "l" }))
            hl.bind(mod .. " + l",  hl.dsp.focus({ direction = "r" }))
            hl.bind(mod .. " + k", function()
              local curr = hl.get_active_window()
              local ws = hl.get_active_workspace()
              if not ws then return end
              local wins = hl.get_workspace_windows(ws)
              if curr then
                for _, w in ipairs(wins) do
                  if w ~= curr and w.at.x == curr.at.x and w.at.y < curr.at.y then
                    hl.dispatch(hl.dsp.focus({ direction = "u" }))
                    return
                  end
                end
              end
              for _, w in ipairs(hl.get_workspaces()) do
                if w.id < ws.id and #hl.get_workspace_windows(w) > 0 then
                  hl.dispatch(hl.dsp.focus({ workspace = "e-1" }))
                  return
                end
              end
              if #wins > 0 and ws.id > 1 then
                hl.dispatch(hl.dsp.focus({ workspace = "-1" }))
              end
            end)
            hl.bind(mod .. " + j", function()
              local curr = hl.get_active_window()
              local ws = hl.get_active_workspace()
              if not ws then return end
              local wins = hl.get_workspace_windows(ws)
              if curr then
                for _, w in ipairs(wins) do
                  if w ~= curr and w.at.x == curr.at.x and w.at.y > curr.at.y then
                    hl.dispatch(hl.dsp.focus({ direction = "d" }))
                    return
                  end
                end
              end
              for _, w in ipairs(hl.get_workspaces()) do
                if w.id > ws.id and #hl.get_workspace_windows(w) > 0 then
                  hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
                  return
                end
              end
              if #wins > 0 then
                hl.dispatch(hl.dsp.focus({ workspace = "+1" }))
              end
            end)

            -- window move
            local function nearest_width(window)
              local ratio = window.size.x / hl.get_active_monitor().width
              local widths = { 0.333, 0.5, 0.667 }
              local best, best_dist = widths[1], math.abs(widths[1] - ratio)
              for _, w in ipairs(widths) do
                local d = math.abs(w - ratio)
                if d < best_dist then best, best_dist = w, d end
              end
              return best
            end

            hl.bind(mod .. " + CTRL + h",  hl.dsp.window.move({ direction = "l" }))
            hl.bind(mod .. " + CTRL + l",  hl.dsp.window.move({ direction = "r" }))
            hl.bind(mod .. " + CTRL + k", function()
              local curr = hl.get_active_window()
              local ws = hl.get_active_workspace()
              if not ws then return end
              local wins = hl.get_workspace_windows(ws)
              local saved = curr and nearest_width(curr) or nil
              if curr then
                for _, w in ipairs(wins) do
                  if w ~= curr and w.at.x == curr.at.x and w.at.y < curr.at.y then
                    hl.dispatch(hl.dsp.window.move({ direction = "u" }))
                    return
                  end
                end
              end
              for _, w in ipairs(hl.get_workspaces()) do
                if w.id < ws.id and #hl.get_workspace_windows(w) > 0 then
                  hl.dispatch(hl.dsp.window.move({ workspace = "e-1" }))
                  if saved then hl.dispatch(hl.dsp.layout("colresize " .. saved)) end
                  return
                end
              end
              if #wins > 1 and ws.id > 1 then
                hl.dispatch(hl.dsp.window.move({ workspace = "-1" }))
                if saved then hl.dispatch(hl.dsp.layout("colresize " .. saved)) end
              end
            end)
            hl.bind(mod .. " + CTRL + j", function()
              local curr = hl.get_active_window()
              local ws = hl.get_active_workspace()
              if not ws then return end
              local wins = hl.get_workspace_windows(ws)
              local saved = curr and nearest_width(curr) or nil
              if curr then
                for _, w in ipairs(wins) do
                  if w ~= curr and w.at.x == curr.at.x and w.at.y > curr.at.y then
                    hl.dispatch(hl.dsp.window.move({ direction = "d" }))
                    return
                  end
                end
              end
              for _, w in ipairs(hl.get_workspaces()) do
                if w.id > ws.id and #hl.get_workspace_windows(w) > 0 then
                  hl.dispatch(hl.dsp.window.move({ workspace = "e+1" }))
                  if saved then hl.dispatch(hl.dsp.layout("colresize " .. saved)) end
                  return
                end
              end
              if #wins > 1 then
                hl.dispatch(hl.dsp.window.move({ workspace = "+1" }))
                if saved then hl.dispatch(hl.dsp.layout("colresize " .. saved)) end
              end
            end)

            -- =========== WINDOW & LAYER RULES ===========
            hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
            hl.window_rule({
              match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
              no_focus = true,
            })
            hl.window_rule({ match = { class = "zen-beta" }, scrolling_width = 0.5 })

            hl.layer_rule({ match = { namespace = "vicinae" }, blur = true, ignore_alpha = 0.0, no_anim = true })
            hl.layer_rule({ match = { namespace = "wayle.*" }, blur = true })
          '';
        };
      };
  };
}
