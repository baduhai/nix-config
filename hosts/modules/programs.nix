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
      environment.systemPackages = with pkgs; [
        ### Dev Tools ###
        agenix
        git
        helix
        ### System Utilities ###
        btop
        fastfetch
        nixos-firewall-tool
        sysz
        wget
        tmux
      ];

      programs = {
        fish.enable = true;
        command-not-found.enable = false;
      };

      environment.shellAliases = {
        ls = "${pkgs.eza}/bin/eza --icons --group-directories-first";
        neofetch = "fastfetch";
        tree = "ls --tree";
        syscleanup = "sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration boot";
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
        environment.systemPackages =
          with pkgs;
          [
            ### Dev Tools ###
            bat
            deploy-rs
            fd
            fzf
            nixfmt-rfc-style
            nix-init
            nix-output-monitor
            ripgrep
            ### Internet Browsers & Communication ###
            firefox
            microsoft-edge
            nextcloud-client
            tor-browser
            ungoogled-chromium
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
            freecad-wayland
            gimp
            inkscape
            orca-slicer
            ### Gaming & Entertainment ###
            clonehero
            heroic
            mangohud
            prismlauncher
            protonup
            ### System Utilities ###
            adwaita-icon-theme
            distrobox
            junction
            kara
            kde-rounded-corners
            libfido2
            # lilipod BROKEN
            mission-center
            p7zip
            plasma-panel-colorizer
            qbittorrent
            quickemu
            quickgui
            steam-run
            unrar
            ventoy
            ### Media ###
            mpv
            obs-studio
            qview
          ]
          ++ kdepkgs;

        services.flatpak = {
          enable = true;
          packages = [
            "com.github.k4zmu2a.spacecadetpinball"
            "com.github.tchx84.Flatseal"
            "com.steamgriddb.SGDBoop"
            "app.zen_browser.zen"
            "io.github.Foldex.AdwSteamGtk"
            "io.itch.itch"
            "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
          ];
          uninstallUnmanaged = true;
          update.auto.enable = true;
        };

        programs = {
          adb.enable = true;
          steam.enable = true;
          dconf.enable = true;
          nix-ld.enable = true;
          kdeconnect.enable = true;
          partition-manager.enable = true;
          gamemode.enable = true;
          nix-index-database.comma.enable = true;
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
            noto-fonts-cjk-sans
            roboto
          ];
        };

        environment.plasma6.excludePackages = (
          with pkgs.kdePackages;
          [
            discover
            elisa
            gwenview
            kate
            khelpcenter
            oxygen
          ]
        );
      }
    ))
  ];
}
