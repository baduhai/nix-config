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
          helix
          ### System Utilities ###
          btop
          fastfetch
          nixos-firewall-tool
          sysz
          wget
          tmux
        ];
        shellAliases = {
          ls = "${pkgs.eza}/bin/eza --icons --group-directories-first";
          neofetch = "fastfetch";
          tree = "ls --tree";
          syscleanup = "sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration boot";
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
              deploy-rs
              fd
              fzf
              nixfmt-rfc-style
              nix-init
              nix-output-monitor
              ripgrep
              ### Internet Browsers & Communication ###
              beeper
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
              orca-slicer
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
              steam-run
              unrar
              ### Media ###
              mpv
              obs-studio
              qview
            ]
            ++ kdepkgs;
          plasma6.excludePackages = (
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
