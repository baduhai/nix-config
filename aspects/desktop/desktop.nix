{
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.desktop-desktop =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.niri-flake.nixosModules.niri
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];

        environment = {
          sessionVariables = {
            KDEHOME = "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
            NIXOS_OZONE_WL = "1"; # Forces chromium and most electron apps to run in wayland
          };
          systemPackages = with pkgs; [
            ### Web ###
            bitwarden-desktop
            fragments
            nextcloud-client
            tor-browser
            vesktop
            inputs.zen-browser.packages."${system}".default
            ### Office & Productivity ###
            aspell
            aspellDicts.de
            aspellDicts.en
            aspellDicts.en-computers
            aspellDicts.pt_BR
            papers
            presenterm
            rnote
            ### Graphics & Design ###
            gimp
            inkscape
            plasticity
            ### System Utilities ###
            adwaita-icon-theme
            ghostty
            gnome-disk-utility
            junction
            libfido2
            mission-center
            nautilus
            p7zip
            rclone
            toggleaudiosink
            unrar
            ### Media ###
            decibels
            loupe
            obs-studio
            showtime
          ];
        };

        services = {
          pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
            wireplumber.enable = true;
          };
          greetd = {
            enable = true;
            settings = {
              default_session = {
                command = "${lib.getExe pkgs.tuigreet} --user-menu --time --remember --asterisks --cmd ${config.programs.niri.package}/bin/niri-session";
                user = "greeter";
              };
            }
            // lib.optionalAttrs (config.networking.hostName == "io") {
              initial_session = {
                command = "${config.programs.niri.package}/bin/niri-session";
                user = "user";
              };
            };
          };
          flatpak = {
            enable = true;
            packages = [
              ### Office & Productivity ###
              "com.collabora.Office"
              ### Graphics & Design ###
              "com.boxy_svg.BoxySVG"
              rec {
                appId = "io.github.softfever.OrcaSlicer";
                sha256 = "0hdx5sg6fknj1pfnfxvlfwb5h6y1vjr6fyajbsnjph5gkp97c6p1";
                bundle = "${pkgs.fetchurl {
                  url = "https://github.com/SoftFever/OrcaSlicer/releases/download/v2.3.0/OrcaSlicer-Linux-flatpak_V2.3.0_x86_64.flatpak";
                  inherit sha256;
                }}";
              }
              ### System Utilities ###
              "com.github.tchx84.Flatseal"
              "com.rustdesk.RustDesk"
            ];
            uninstallUnmanaged = true;
            update.auto.enable = true;
          };
          gvfs.enable = true;
        };

        security.rtkit.enable = true; # Needed for pipewire to acquire realtime priority

        users = {
          users.greeter = {
            isSystemUser = true;
            group = "greeter";
          };
          groups.greeter = { };
        };

        programs = {
          niri = {
            enable = true;
            package = inputs.niri.packages.${pkgs.system}.niri;
          };
          kdeconnect = {
            enable = true;
            package = pkgs.valent;
          };
          dconf.enable = true;
          appimage = {
            enable = true;
            binfmt = true;
          };
        };

        niri-flake.cache.enable = false;

        fonts = {
          fontDir.enable = true;
          packages = with pkgs; [
            corefonts
            inter
            nerd-fonts.fira-code
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            roboto
          ];
        };

        xdg.portal = {
          extraPortals = with pkgs; [
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
          config = {
            common.default = "*";
            niri.default = [
              "gtk"
              "gnome"
            ];
          };
        };
      };

    homeManager.desktop-desktop =
      {
        config,
        lib,
        pkgs,
        inputs,
        ...
      }:
      {
        imports = [ inputs.vicinae.homeManagerModules.default ];

        fonts.fontconfig.enable = true;

        home.packages = with pkgs; [ xwayland-satellite ];

        services.vicinae = {
          enable = true;
          systemd = {
            enable = true;
            autoStart = true;
          };
        };

        programs = {
          ghostty = {
            enable = true;
            settings = {
              cursor-style = "block";
              shell-integration-features = "no-cursor";
              cursor-style-blink = false;
              custom-shader = "${builtins.fetchurl {
                url = "https://raw.githubusercontent.com/hackr-sh/ghostty-shaders/cb6eb4b0d1a3101c869c62e458b25a826f9dcde3/cursor_blaze.glsl";
                sha256 = "sha256:0g2lgqjdrn3c51glry7x2z30y7ml0y61arl5ykmf4yj0p85s5f41";
              }}";
              bell-features = "";
              gtk-titlebar-style = "tabs";
              keybind = [ "shift+enter=text:\\x1b\\r" ];
            };
          };

          password-store = {
            enable = true;
            package = pkgs.pass-wayland;
          };
        };

        xdg = {
          enable = true;
          userDirs.enable = true;
          mimeApps = {
            enable = true;
            defaultApplications = {
              "text/html" = [
                "re.sonny.Junction.desktop"
                "zen-browser.desktop"
                "torbrowser.desktop"
              ];
              "x-scheme-handler/http" = [
                "re.sonny.Junction.desktop"
                "zen-browser.desktop"
                "torbrowser.desktop"
              ];
              "x-scheme-handler/https" = [
                "re.sonny.Junction.desktop"
                "zen-browser.desktop"
                "torbrowser.desktop"
              ];
              "x-scheme-handler/about" = [
                "re.sonny.Junction.desktop"
                "zen-browser.desktop"
                "torbrowser.desktop"
              ];
              "x-scheme-handler/unknown" = [
                "re.sonny.Junction.desktop"
                "zen-browser.desktop"
                "torbrowser.desktop"
              ];
              "image/jpeg" = "org.gnome.Loupe.desktop";
              "image/png" = "org.gnome.Loupe.desktop";
              "image/gif" = "org.gnome.Loupe.desktop";
              "image/webp" = "org.gnome.Loupe.desktop";
              "image/bmp" = "org.gnome.Loupe.desktop";
              "image/svg+xml" = "org.gnome.Loupe.desktop";
              "image/tiff" = "org.gnome.Loupe.desktop";
              "video/mp4" = "io.bassi.Showtime.desktop";
              "video/x-matroska" = "io.bassi.Showtime.desktop";
              "video/webm" = "io.bassi.Showtime.desktop";
              "video/mpeg" = "io.bassi.Showtime.desktop";
              "video/x-msvideo" = "io.bassi.Showtime.desktop";
              "video/quicktime" = "io.bassi.Showtime.desktop";
              "video/x-flv" = "io.bassi.Showtime.desktop";
              "audio/mpeg" = "io.bassi.Showtime.desktop";
              "audio/flac" = "io.bassi.Showtime.desktop";
              "audio/ogg" = "io.bassi.Showtime.desktop";
              "audio/wav" = "io.bassi.Showtime.desktop";
              "audio/mp4" = "io.bassi.Showtime.desktop";
              "audio/x-opus+ogg" = "io.bassi.Showtime.desktop";
              "application/pdf" = [
                "org.gnome.Papers.desktop"
                "zen-browser.desktop"
              ];
              "text/plain" = "Helix.desktop";
              "text/markdown" = "Helix.desktop";
              "text/x-log" = "Helix.desktop";
              "application/x-shellscript" = "Helix.desktop";
              "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
                "com.collabora.Office.desktop"; # DOCX
              "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
                "com.collabora.Office.desktop"; # XLSX
              "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
                "com.collabora.Office.desktop"; # PPTX
              "application/vnd.oasis.opendocument.text" = "com.collabora.Office.desktop"; # ODT
              "application/vnd.oasis.opendocument.spreadsheet" = "com.collabora.Office.desktop"; # ODS
              "application/vnd.oasis.opendocument.presentation" = "com.collabora.Office.desktop"; # ODP
              "application/msword" = "com.collabora.Office.desktop"; # DOC
              "application/vnd.ms-excel" = "com.collabora.Office.desktop"; # XLS
              "application/vnd.ms-powerpoint" = "com.collabora.Office.desktop"; # PPT
              "application/zip" = "org.gnome.FileRoller.desktop";
              "application/x-tar" = "org.gnome.FileRoller.desktop";
              "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
              "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop";
              "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop";
              "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
              "application/x-rar" = "org.gnome.FileRoller.desktop";
              "application/gzip" = "org.gnome.FileRoller.desktop";
              "application/x-bzip" = "org.gnome.FileRoller.desktop";
              "inode/directory" = "org.gnome.Nautilus.desktop";
            };
          };
        };

        # Set Ghostty as default terminal
        home.sessionVariables = {
          TERMINAL = "ghostty";
        };
      };
  };
}
