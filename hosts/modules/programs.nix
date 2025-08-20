{
  hostType,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      environment = {
        systemPackages = with pkgs; [
          ### Dev Tools ###
          agenix
          git
          ### System Utilities ###
          btop
          nixos-firewall-tool
          nvd
          sysz
          tmux
          wget
          yazi
        ];
        shellAliases = {
          ls = "${pkgs.eza}/bin/eza --icons --group-directories-first";
          neofetch = "${pkgs.fastfetch}/bin/fastfetch";
          tree = "ls --tree";
          vi = "${pkgs.evil-helix}/bin/hx";
          vim = "${pkgs.evil-helix}/bin/hx";
          nvim = "${pkgs.evil-helix}/bin/hx";
        };
      };

      programs = {
        fish.enable = true;
        command-not-found.enable = false;
      };
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation (
      let
        kdepkgs = with pkgs.kdePackages; [
          ark
          dolphin-plugins
          kolourpaint
        ];
        kwrite = pkgs.symlinkJoin {
          name = "kwrite";
          paths = [ pkgs.kdePackages.kate ];
          postBuild = ''
            rm -rf $out/bin/kate \
                   $out/bin/.kate-wrapped \
                   $out/share/applications/org.kde.kate.desktop \
                   $out/share/man \
                   $out/share/icons/hicolor/*/apps/kate.png \
                   $out/share/icons/hicolor/scalable/apps/kate.svg \
                   $out/share/appdata/org.kde.kate.appdata.xml
          '';
        };
      in
      {
        environment = {
          systemPackages =
            with pkgs;
            [
              ### Dev Tools ###
              bat
              lazygit
              # ciscoPacketTracer8
              fd
              fzf
              glow
              nixfmt-rfc-style
              nix-init
              nix-output-monitor
              ripgrep
              ### Internet Browsers & Communication ###
              brave
              tor-browser
              vesktop
              ### Office & Productivity ###
              aspell
              aspellDicts.de
              aspellDicts.en
              aspellDicts.en-computers
              aspellDicts.pt_BR
              kwrite
              libreoffice-qt
              obsidian
              onlyoffice-desktopeditors
              rnote
              ### Graphics & Design ###
              gimp
              inkscape
              plasticity
              ### Gaming & Entertainment ###
              clonehero
              heroic
              mangohud
              prismlauncher
              protonup
              ### System Utilities ###
              adwaita-icon-theme
              junction
              kara
              kde-rounded-corners
              libfido2
              mission-center
              p7zip
              qbittorrent
              quickemu
              quickgui
              rclone
              steam-run
              toggleaudiosink
              unrar
              ### Media ###
              mpv
              obs-studio
              qview
            ]
            ++ kdepkgs;
          plasma6.excludePackages = with pkgs.kdePackages; [
            discover
            elisa
            gwenview
            kate
            khelpcenter
            konsole
            oxygen
          ];
        };

        programs = {
          adb.enable = true;
          steam = {
            enable = true;
            extraCompatPackages = [ pkgs.proton-ge-bin ];
          };
          dconf.enable = true;
          nix-ld.enable = true;
          kdeconnect.enable = true;
          partition-manager.enable = true;
          gamemode.enable = true;
          appimage = {
            enable = true;
            binfmt = true;
          };
          nh = {
            enable = true;
            flake = "/home/user/Projects/personal/nix-config";
          };
        };

        fonts = {
          fontDir.enable = true;
          packages = with pkgs; [
            corefonts
            inter
            nerd-fonts.hack
            noto-fonts-cjk-sans
            roboto
          ];
        };

        services.flatpak = {
          enable = true;
          packages = [
            ### Dev Tools ###
            ### Internet Browsers & Communication ###
            "app.zen_browser.zen"
            ### Office & Productivity ###
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
            ### Gaming & Entertainment ###
            "com.github.k4zmu2a.spacecadetpinball"
            "io.itch.itch"
            "io.mrarm.mcpelauncher"
            "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
            ### System Utilities ###
            "com.github.tchx84.Flatseal"
            "com.rustdesk.RustDesk"
            "com.steamgriddb.SGDBoop"
            "io.github.Foldex.AdwSteamGtk"
            ### Media ###
          ];
          uninstallUnmanaged = true;
          update.auto.enable = true;
        };
      }
    ))
  ];
}
