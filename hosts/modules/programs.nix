{
  hostType,
  inputs,
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

      services.flatpak.enable = lib.mkDefault false;
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation ({
      environment.systemPackages = with pkgs; [
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
        libreoffice-qt
        obsidian
        (octaveFull.withPackages (octavePackages: with octavePackages; [ signal ]))
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
        ### System Utilities ###
        adwaita-icon-theme
        junction
        kara
        kde-rounded-corners
        libfido2
        morewaita-icon-theme
        nautilus
        mission-center
        p7zip
        qbittorrent
        quickemu
        quickgui
        rustdesk
        steam-run
        toggleaudiosink
        unrar
        ### Media ###
        mpv
        obs-studio
        qview
      ];

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
          "io.github.Foldex.AdwSteamGtk"
          "com.steamgriddb.SGDBoop"
          ### Media ###
        ];
        uninstallUnmanaged = true;
        update.auto.enable = true;
      };
    }))
  ];
}
