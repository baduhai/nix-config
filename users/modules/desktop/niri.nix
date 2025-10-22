{
  inputs,
  lib,
  pkgs,
  hostname ? null,
  ...
}:

let
  isRotterdam = hostname == "rotterdam";
  noctalia = "${lib.getExe inputs.noctalia.packages.${pkgs.system}.default}";
in

{
  imports = [ inputs.noctalia.homeModules.default ];
  home.packages = with pkgs; [ xwayland-satellite ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

  xdg.configFile."niri/config.kdl".text = ''
    output "eDP-1" {
      scale 1.0
    }
    output "DP-3" {
      scale 1.0
    }

    input {
      keyboard {
        xkb {
          layout "us"
          variant "altgr-intl"
        }
      }
      touchpad {
        tap
        dwt
        drag true
        drag-lock
        natural-scroll
        accel-speed 0.2
        accel-profile "flat"
        scroll-method "two-finger"
        middle-emulation
      }
      mouse {
        natural-scroll
        accel-speed 0.2
        accel-profile "flat"
      }
      warp-mouse-to-focus mode="center-xy"
      focus-follows-mouse
    }

    layout {
      gaps 8
      center-focused-column "never"
      auto-center-when-space-available
      preset-column-widths {
        ${
          if isRotterdam then
            ''
              proportion 0.33333
                  proportion 0.5
                  proportion 0.66667
            ''
          else
            ''
              proportion 0.5
                  proportion 1.0
            ''
        }
      }
      default-column-width { proportion ${if isRotterdam then "0.33333" else "0.5"}; }
      focus-ring {
        off
      }
      border {
        width 4
        active-color "#ffc87f"
        inactive-color "#505050"
        urgent-color "#9b0000"
      }
        tab-indicator {
          width 4
          gap 4
          place-within-column
        }
        struts {
          left 8
          right 8
        }
    }

    overview {
      zoom 0.65
    }

    spawn-at-startup "${noctalia}"
    spawn-at-startup "${lib.getExe pkgs.valent}"
    layer-rule {
      match namespace="^wallpaper$"
        place-within-backdrop true
    }
    layer-rule {
      match namespace="^quickshell-overview$"
      place-within-backdrop true
    }

    hotkey-overlay {
      skip-at-startup
    }

    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    animations {
      slowdown 0.3
    }

    window-rule {
      match app-id="zen"
      default-column-width { proportion ${if isRotterdam then "0.5" else "1.0"}; }
    }

    window-rule {
      geometry-corner-radius 12
      clip-to-geometry true
    }

    config-notification {
      disable-failed
    }

    binds {
      Alt+Space { spawn "${noctalia}" "ipc" "call" "launcher" "toggle"; }
      XF86AudioRaiseVolume { spawn "${noctalia}" "ipc" "call" "volume" "increase"; }
      XF86AudioLowerVolume { spawn "${noctalia}" "ipc" "call" "volume" "decrease"; }
      XF86AudioMute { spawn "${noctalia}" "ipc" "call" "volume" "muteOutput"; }
      XF86MonBrightnessUp { spawn "${noctalia}" "ipc" "call" "brightness" "increase"; }
      XF86MonBrightnessDown { spawn "${noctalia}" "ipc" "call" "brightness" "decrease"; }
      Mod+V { spawn "${noctalia}" "ipc" "call" "launcher" "clipboard"; }
      Mod+Shift+L { spawn "${noctalia}" "ipc" "call" "lockScreen" "toggle"; }
      Mod+Return { spawn "ghostty"; }
      Ctrl+Alt+Shift+A allow-when-locked=true { spawn "toggleaudiosink"; }
      Mod+W repeat=false { toggle-overview; }
      Mod+Q { close-window; }
      Alt+Shift+Q { close-window;}
      Mod+Shift+Q { close-window; }
      Alt+F4 { close-window; }
      Mod+Left  { focus-column-left; }
      Mod+Down  { focus-window-down; }
      Mod+Up    { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+H     { focus-column-left; }
      Mod+L     { focus-column-right; }
      Mod+J     { focus-window-down; }
      Mod+K     { focus-window-up; }
      Ctrl+Alt+J    { focus-workspace-down; }
      Ctrl+Alt+K    { focus-workspace-up; }
      Ctrl+Alt+Down { focus-workspace-down; }
      Ctrl+Alt+Up   { focus-workspace-up; }
      Mod+Ctrl+Left  { move-column-left; }
      Mod+Ctrl+Down  { move-window-down-or-to-workspace-down; }
      Mod+Ctrl+Up    { move-window-up-or-to-workspace-up; }
      Mod+Ctrl+Right { move-column-right; }
      Mod+Ctrl+H     { move-column-left; }
      Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
      Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }
      Mod+Ctrl+L     { move-column-right; }
      Mod+Home { focus-column-first; }
      Mod+End  { focus-column-last; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End  { move-column-to-last; }
      Mod+Alt+Left  { focus-monitor-left; }
      Mod+Alt+Down  { focus-monitor-down; }
      Mod+Alt+Up    { focus-monitor-up; }
      Mod+Alt+Right { focus-monitor-right; }
      Mod+Alt+H     { focus-monitor-left; }
      Mod+Alt+J     { focus-monitor-down; }
      Mod+Alt+K     { focus-monitor-up; }
      Mod+Alt+L     { focus-monitor-right; }
      Mod+Alt+Ctrl+Left  { move-column-to-monitor-left; }
      Mod+Alt+Ctrl+Down  { move-column-to-monitor-down; }
      Mod+Alt+Ctrl+Up    { move-column-to-monitor-up; }
      Mod+Alt+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Alt+Ctrl+H     { move-column-to-monitor-left; }
      Mod+Alt+Ctrl+J     { move-column-to-monitor-down; }
      Mod+Alt+Ctrl+K     { move-column-to-monitor-up; }
      Mod+Alt+Ctrl+L     { move-column-to-monitor-right; }
      Mod+Ctrl+U         { move-workspace-down; }
      Mod+Ctrl+I         { move-workspace-up; }
      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
      Mod+Shift+WheelScrollDown      { focus-column-right; }
      Mod+Shift+WheelScrollUp        { focus-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
      Mod+BracketLeft  { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }
      Mod+Comma  { consume-window-into-column; }
      Mod+Period { expel-window-from-column; }
      Mod+R { switch-preset-column-width; }
      Mod+F { maximize-column; }
      Mod+Ctrl+F { fullscreen-window; }
      Mod+C { center-visible-columns; }
      Mod+Ctrl+C { center-column; }
      Mod+Space       { toggle-window-floating; }
      Mod+Ctrl+Space  { switch-focus-between-floating-and-tiling; }
      Mod+T { toggle-column-tabbed-display; }
      Print { screenshot-screen; }
      Mod+Print { screenshot; }
      Ctrl+Print { screenshot-window; }
      Mod+Backspace allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      Mod+Alt+E { spawn "${noctalia}" "ipc" "call" "sessionMenu" "toggle"; }
      Ctrl+Alt+Delete { spawn "${noctalia}" "ipc" "call" "sessionMenu" "toggle"; }
      Mod+Ctrl+P { power-off-monitors; }
    }
  '';
}
