{
  config,
  hostType,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      home = {
        packages = with pkgs; [ nix-your-shell ];
      };

      programs = {
        helix.languages = {
          language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "nixfmt";
            }
            {
              name = "typst";
              auto-format = true;
              formatter.command = "typstyle -c 1000 -i";
            }
          ];
        };

        password-store.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        fish = {
          interactiveShellInit = "nix-your-shell fish | source";
          loginShellInit = "nix-your-shell fish | source";
        };

        tmux = {
          enable = true;
          clock24 = true;
          terminal = "xterm-256color";
          mouse = true;
          keyMode = "vi";
        };

        starship = {
          enable = true;
          enableBashIntegration = true;
          enableFishIntegration = true;
          settings = {
            add_newline = false;
            format = ''
              $hostname$directory$git_branch$git_status$nix_shell
              [ ❯ ](bold green)
            '';
            right_format = "$cmd_duration$character";
            hostname = {
              ssh_symbol = " ";
            };
            character = {
              error_symbol = "[](red)";
              success_symbol = "[󱐋](green)";
            };
            cmd_duration = {
              format = "[󰄉 $duration ]($style)";
              style = "yellow";
              min_time = 500;
            };
            git_branch = {
              symbol = " ";
              style = "purple";
            };
            git_status.style = "red";
            nix_shell = {
              format = "via [$symbol$state]($style)";
              heuristic = true;
              style = "blue";
              symbol = "󱄅 ";
            };
          };
        };

        git = {
          enable = true;
          diff-so-fancy.enable = true;
          userName = "William";
          userEmail = "baduhai@proton.me";
        };

        btop = {
          enable = true;
          settings = {
            theme_background = false;
            proc_sorting = "cpu direct";
            update_ms = 500;
          };
        };
      };
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {

    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
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
        dankMaterialShell = {
          enable = true;
          enableVPN = false;
        };
        rio = {
          enable = true;
          settings = {
            window = {
              width = 1121;
              height = 633;
            };
          };
        };
      };
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          ################
          ### MONITORS ###
          ################
          monitor=,preferred,auto,auto
          ################
          ### START-UP ###
          ################
          exec-once = bash -c "wl-paste --watch cliphist store &"
          exec-once = /usr/lib/mate-polkit/polkit-mate-authentication-agent-1
          exec-once = dms run
          #####################
          ### LOOK AND FEEL ###
          #####################
          general {
            gaps_in = 5
            gaps_out = 20
            border_size = 2
            resize_on_border = true
            allow_tearing = false
            layout = dwindle
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
            animation = global, 1, 1, default
            animation = border, 1, 1, easeOutQuint
            animation = windows, 1, 1, easeOutQuint
            animation = windowsIn, 1, 0.3, quick, popin 95%  # Much faster: 30ms with quick bezier
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
          $terminal = rio
          $menu = dms ipc call spotlight toggle
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
          # bind = $mainMod, r, scroller:cyclewidth, next
          # bind = $mainMod CTRL, r, scroller:cyclewidth, prev
          # bind = $mainMod, p, scroller:pin,
          # bind = $mainMod, c, scroller:alignwindow, center
          # bind = $mainMod CTRL, f, scroller:fitsize, all

          ####################
          ### WINDOW RULES ###
          ####################
          windowrulev2 = suppressevent maximize, class:.*
          windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
        '';
      };
      fonts.fontconfig.enable = true;
    })
  ];
}
