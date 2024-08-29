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
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze";
    };
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "Breeze";
    };
  };

  home.packages = with pkgs;
    [
      (symlinkJoin {
        name = "firefoxWork";
        paths = [
          (pkgs.makeDesktopItem {
            name = "firefoxWorkDesktopItem";
            desktopName = "Firefox Work";
            genericName = "Web Browser - Work Profile";
            categories = [ "Network" "WebBrowser" ];
            icon = "firefoxWork";
            exec =
              ''firefox --name firefoxWork --class="firefoxWork" -P Work %U'';
            startupNotify = true;
            startupWMClass = "firefoxWork";
            terminal = false;
            type = "Application";
          })
          (stdenv.mkDerivation {
            name = "firefoxWorkIcon";
            src = pkgs.fetchurl {
              url =
                "https://hg.mozilla.org/mozilla-central/raw-file/tip/browser/branding/aurora/content/about-logo.svg";
              sha256 = "sha256-dHuMm4ZdnihpgvSpbC4xPQIidN22LmbgDC8h7MJV0Tk=";
            };
            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/share/icons/hicolor/scalable/apps/
              cp $src $out/share/icons/hicolor/scalable/apps/firefoxWork.svg
            '';
          })
        ];
      })
    ];

  # xdg.desktopEntries = {
  #   firefoxWork = {
  #     name = "Firefox Work";
  #     genericName = "Web Browser - Work Profile";
  #     categories = [ "Network" "WebBrowser" ];
  #     icon = pkgs.fetchurl {
  #       url =
  #         "https://hg.mozilla.org/mozilla-central/raw-file/tip/browser/branding/aurora/content/about-logo.svg";
  #       sha256 = "sha256-dHuMm4ZdnihpgvSpbC4xPQIidN22LmbgDC8h7MJV0Tk=";
  #     };
  #     exec = ''firefox --name firefoxWork --class="firefoxWork" -P Work %U'';
  #     startupNotify = true;
  #     terminal = false;
  #     type = "Application";
  #   };
  # };

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

    fish = {
      functions = {
        sysrebuild =
          "nh os switch --ask /home/user/Projects/personal/nix-config";
        sysrebuild-boot =
          "nh os boot --ask /home/user/Projects/personal/nix-config";
        sysupdate =
          "nix flake update --commit-lock-file /home/user/Projects/personal/nix-config";
        syscleanup =
          "sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration boot";
        code = ''
          wezterm cli split-pane --top --percent=75 -- hx
          wezterm cli activate-pane-direction up          
        '';
      };
    };
  };

  home.file = {
    ".config/MangoHud/MangoHud.conf".text = ''
      time
      fps
      gpu_stats
      gpu_temp
      vram
      cpu_stats
      cpu_temp
      ram
      frame_timing
      battery_icon
      gamepad_battery_icon

      horizontal
      horizontal_stretch=0
      legacy_layout=0
      background_alpha=0.6
      position=top-left
      control=mangohud
      offset_x=4
      offset_y=4
      table_columns=20
      time_format=%H:%M
      toggle_hud=End

      core_load_change
      cpu_color=ffffff
      cpu_load_change
      cpu_load_color=FFFFFF,FFAA7F,CC0000
      cpu_load_value=50,90
      cpu_text=CPU

      gpu_color=ffffff
      gpu_load_change
      gpu_load_color=FFFFFF,FFAA7F,CC0000
      gpu_load_value=50,90
      gpu_text=GPU

      io_color=ffffff
      media_player_color=ffffff
      ram_color=ffffff
      text_color=ffffff
      vram_color=ffffff
      engine_color=ffffff
      frametime_color=ffffff

      blacklist=zed,org.wezfurlong.wezterm
    '';
    ".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
      "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };
}
