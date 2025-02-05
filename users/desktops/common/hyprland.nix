{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [ hyprscroller ];
    extraConfig = ''
      ################
      ### MONITORS ###
      ################
      monitor=,preferred,auto,auto

      #################
      ### AUTOSTART ###
      #################
      exec-once = ulauncher --hide-window
      # exec-once = ${pkgs.swaynotificationcenter}/bin/swaync
      # exec-once = ${pkgs.ironbar}/bin/ironbar
      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24

      #####################
      ### LOOK AND FEEL ###
      #####################
      general {
        gaps_in = 5
        gaps_out = 20
        border_size = 2
        resize_on_border = true
        allow_tearing = false
        layout = scroller
      }
      plugin {
        scroller {
          column_default_width = onethird
          focuswrap = false
          column_widths = onethird onehalf twothirds
          center_row_if_space_available = true
        }
      }
      decoration {
        rounding = 10
        rounding_power = 2
        dim_inactive = true
        dim_strength = 0.3
        shadow {
          enabled = true
          range = 4
          render_power = 3
        }
        blur {
          enabled = true
          size = 8
          passes = 1
          vibrancy = 0.1696
        }
      }
      animations {
        enabled = yes, please :)
        bezier = easeOutQuint,0.23,1,0.32,1
        bezier = easeInOutCubic,0.65,0.05,0.36,1
        bezier = linear,0,0,1,1
        bezier = almostLinear,0.5,0.5,0.75,1.0
        bezier = quick,0.15,0,0.1,1
        animation = global, 1, 10, default
        animation = border, 1, 5.39, easeOutQuint
        animation = windows, 1, 4.79, easeOutQuint
        animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
        animation = windowsOut, 1, 1.49, linear, popin 87%
        animation = fadeIn, 1, 1.73, almostLinear
        animation = fadeOut, 1, 1.46, almostLinear
        animation = fade, 1, 3.03, quick
        animation = layers, 1, 3.81, easeOutQuint
        animation = layersIn, 1, 4, easeOutQuint, fade
        animation = layersOut, 1, 1.5, linear, fade
        animation = fadeLayersIn, 1, 1.79, almostLinear
        animation = fadeLayersOut, 1, 1.39, almostLinear
        animation = workspaces, 1, 1.94, almostLinear, fade
        animation = workspacesIn, 1, 1.21, almostLinear, fade
        animation = workspacesOut, 1, 1.94, almostLinear, fade
      }
      misc {
        force_default_wallpaper = 0
        disable_hyprland_logo = true
      }

      #############
      ### INPUT ###
      #############
      input {
        kb_layout = us
        kb_variant = altgr-intl
        follow_mouse = 1
        sensitivity = 0
        accel_profile = flat
        natural_scroll = true
        touchpad {
          natural_scroll = true
          clickfinger_behavior = true
        }
      }

      ###################
      ### KEYBINDINGS ###
      ###################
      $mainMod = SUPER
      $terminal = ghostty
      $menu = ulauncher-toggle
      # APP SHORTCUTS
      bind = ALT, SPACE, exec, $menu
      bind = $mainMod, RETURN, exec, $terminal
      # SESSION MANAGEMENT
      bind = CTRL ALT, DELETE, exit,
      bind = $mainMod CTRL, mouse_down, workspace, e+1
      bind = $mainMod CTRL, mouse_up, workspace, e-1
      bind = $mainMod CTRL, j, workspace, e+1
      bind = $mainMod CTRL, k, workspace, e-1
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-
      bindl = , XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next
      bindl = , XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bindl = , XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bindl = , XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous
      # WINDOW MANAGEMENT
      bind = ALT, F4, killactive,
      bind = $mainMod, space, togglefloating,
      bind = $mainMod, f, fullscreen
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      bind = SUPER, h, movefocus, l
      bind = SUPER, l, movefocus, r
      bind = SUPER, k, movefocus, u
      bind = SUPER, j, movefocus, d
      bind = $mainMod CTRL, h, movewindow, l
      bind = $mainMod CTRL, l, movewindow, r
      bind = $mainMod CTRL, k, movewindow, u
      bind = $mainMod CTRL, j, movewindow, d
      bind = $mainMod, bracketleft, scroller:setmode, row
      bind = $mainMod, bracketright, scroller:setmode, col
      bind = $mainMod, slash, scroller:jump,
      bind = $mainMod, r, scroller:cyclewidth, next
      bind = $mainMod CTRL, r, scroller:cyclewidth, prev
      bind = $mainMod, p, scroller:pin,
      bind = $mainMod, c, scroller:alignwindow, center

      ####################
      ### WINDOW RULES ###
      ####################
      windowrulev2 = suppressevent maximize, class:.*
      windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
      # ulauncher
      windowrule = float, ulauncher
      windowrule = pin, ulauncher
      windowrule = noborder, ulauncher
      windowrule = noshadow, ulauncher
      windowrule = nomaxsize, ulauncher
      windowrule = noblur, ulauncher
      windowrulev2 = animation slide top, class:^(ulauncher)$
      # firefox
      windowrulev2 = plugin:scroller:columnwidth onehalf, class:(firefox)
    '';
  };

  home.packages = with pkgs; [
    hyprnome
    playerctl
    brightnessctl
    ulauncher
  ];
}
