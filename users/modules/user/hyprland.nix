{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  heightfittr = pkgs.writeShellApplication {
    name = "heightfittr";
    runtimeInputs = with pkgs; [
      socat
      hyprland
    ];
    text = ''
      function handle {
        case "$1" in
          *openwindow*)
            hyprctl dispatch scroller:fitheight all > /dev/null
            ;;
          *closewindow*)
            hyprctl dispatch scroller:fitheight all > /dev/null
            ;;
        esac
      }
      socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
        handle "$line"
      done
    '';
  };

  scrollermodetoggle = pkgs.writeShellApplication {
    name = "scrollermodetoggle";
    runtimeInputs = with pkgs; [ hyprland ];
    text = ''
      if [ -f "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/colmode" ]; then
        rm "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/colmode"
        hyprctl --batch 'dispatch scroller:setmode row; notify 2 1000 0 "Row Mode"'
      else
        touch "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/colmode"
        hyprctl --batch 'dispatch scroller:setmode col; notify 2 1000 0 "Column Mode"'
      fi
    '';
  };
in

{
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [ hyprscroller ];
    extraConfig = ''
      ################
      ### MONITORS ###
      ################
      monitor=,preferred,auto,1

      #################
      ### AUTOSTART ###
      #################
      exec-once = ${pkgs.gnome-settings-daemon}/libexec/gsd-rfkill
      exec-once = waybar
      exec-once = syshud
      exec-once = ${lib.getExe heightfittr}
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
      misc {
        font_family = Inter
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
        layerrule = blur, waybar
        layerrule = ignorealpha 0.5, waybar
        layerrule = ignorezero, waybar
      }
      animations {
        enabled = yes, please :)
        bezier = easeOutQuint,0.23,1,0.32,1
        bezier = easeInOutCubic,0.65,0.05,0.36,1
        bezier = linear,0,0,1,1
        bezier = almostLinear,0.5,0.5,0.75,1.0
        bezier = quick,0.15,0,0.1,1
        animation = global, 1, 1, default
        animation = border, 1, 1, easeOutQuint
        animation = windows, 1, 1, easeOutQuint
        animation = windowsIn, 1, 1, easeOutQuint, popin 87%
        animation = windowsOut, 1, 1, linear, popin 87%
        animation = fadeIn, 1, 1, almostLinear
        animation = fadeOut, 1, 1, almostLinear
        animation = fade, 1, 1, quick
        animation = layers, 1, 1, easeOutQuint
        animation = layersIn, 1, 1, easeOutQuint, fade
        animation = layersOut, 1, 1, linear, fade
        animation = fadeLayersIn, 1, 1, almostLinear
        animation = fadeLayersOut, 1, 1, almostLinear
        animation = workspaces, 1, 1, almostLinear, slidevert
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
      bind = $mainMod, mouse_up, exec, hyprnome
      bind = $mainMod, mouse_down, exec, hyprnome --previous
      bind = CTRL ALT, j, exec, hyprnome
      bind = CTRL ALT, k, exec, hyprnome --previous
      bind = $mainMod CTRL ALT, j, exec, hyprnome --move
      bind = $mainMod CTRL ALT, k, exec, hyprnome --move --previous
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous
      bind = CTRL ALT SHIFT, a, exec, bash /home/user/.local/bin/toggle-audio-output.sh
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
      bind = $mainMod, v, exec, ${lib.getExe scrollermodetoggle}
      bind = $mainMod, r, scroller:cyclewidth, next
      bind = $mainMod CTRL, r, scroller:cyclewidth, prev
      bind = $mainMod, p, scroller:pin,
      bind = $mainMod, c, scroller:alignwindow, center
      bind = $mainMod CTRL, f, scroller:fitsize, all

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
      windowrulev2 = float, class:^(firefox)$,title:^(Extension.*)$
      windowrulev2 = plugin:scroller:columnwidth onehalf, class:(firefox)
    '';
  };

  services = {
    swaync = {
      enable = true;
      settings = {
        positionX = "left";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";
        control-center-margin-top = 20;
        control-center-margin-bottom = 20;
        control-center-margin-right = 20;
        control-center-margin-left = 20;
        notification-2fa-action = true;
        notification-inline-replies = false;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        timeout = 10;
        timeout-low = 5;
        timeout-critical = 0;
        fit-to-screen = true;
        relative-timestamps = true;
        control-center-width = 500;
        control-center-height = 600;
        notification-window-width = 500;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = false;
        hide-on-action = true;
        script-fail-notify = true;
        widgets = [
          "inhibitors"
          "title"
          "dnd"
          "notifications"
          "mpris"
        ];
        widget-config = {
          inhibitors = {
            text = "Inhibitors";
            button-text = "Clear All";
            clear-all-button = true;
          };
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear All";
          };
          dnd = {
            text = "Do Not Disturb";
          };
          mpris = {
            image-size = 96;
            image-radius = 12;
          };
        };
      };
    };
    clipman.enable = true;
  };

  programs = {
    hyprlock.enable = true;
  };

  home.packages = with pkgs; [
    brightnessctl
    ghostty
    hyprnome
    playerctl
    swaynotificationcenter
    syshud
    ulauncher
    waybar
    inputs.mithril.packages.${pkgs.system}.mithril-control-center
  ];
}
