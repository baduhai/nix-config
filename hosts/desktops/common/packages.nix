{ inputs, config, pkgs, lib, ... }:
let
  kdepkgs = with pkgs.kdePackages; [
    ark
    discover
    dolphin-plugins
    kaccounts-integration
    kaccounts-providers
    kate
  ];
in {
  environment.systemPackages = with pkgs;
    [
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.pt_BR
      bat
      (blender-hip.withPackages (p: [ python311Packages.py-slvs ]))
      deploy-rs
      distrobox
      fd
      filelight
      firefox
      foliate
      fzf
      gamescope
      gimp
      helvum
      heroic
      inkscape
      # itch # Currently broken
      junction
      kde-rounded-corners
      kolourpaint
      krita
      libfido2
      libreoffice-qt
      mangohud
      mpv
      nextcloud-client
      nix-init
      nix-output-monitor
      obs-studio
      ocs-url
      openscad
      p7zip
      platformio
      prismlauncher
      protonup
      pulseaudio
      qbittorrent
      quickemu
      qview
      ripgrep
      solvespace
      space-cadet-pinball
      sparrow
      steam-run
      thunderbird
      ungoogled-chromium
      unrar
      ventoy
      virt-manager
      yad
      wezterm
      zed-editor
      (appimageTools.wrapType2 rec {
        pname = "ondsel-es";
        version = "2024.2.2";

        src = fetchurl {
          url =
            "https://github.com/Ondsel-Development/FreeCAD/releases/download/2024.2.2/Ondsel_ES_2024.2.2.37240-Linux-x86_64.AppImage";
          hash = "sha256-UrCftzDV4HJWOK4QxFKZUOZ/dJquiLu/e9WTfdo1Sh0=";
        };

        extraInstallCommands = let
          appimageContents =
            appimageTools.extractType2 { inherit pname version src; };
        in ''
          install -Dm444 ${appimageContents}/com.ondsel.ES.desktop -t $out/share/applications/
          install -Dm444 ${appimageContents}/Ondsel.svg -t $out/share/pixmaps/
        '';

        extraPkgs = pkgs: [ pkgs.python313 ];

        meta = with lib; {
          homepage = "https://www.ondsel.com";
          license = licenses.lgpl2Plus;
          platforms = platforms.linux;
        };
      })
    ] ++ kdepkgs;

  programs = {
    adb.enable = true;
    steam.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    kdeconnect.enable = true;
    partition-manager.enable = true;
    gamemode.enable = true;
    nix-index-database.comma.enable = true;
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d";
      };
      flake = "/home/user/Projects/nix-config";
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      corefonts
      inter
      maple-mono
      roboto
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };

  environment.plasma6.excludePackages =
    (with pkgs.kdePackages; [ elisa gwenview oxygen khelpcenter ]);
}
