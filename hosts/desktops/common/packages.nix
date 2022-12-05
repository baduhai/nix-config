{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    arduino
    ark
    bat
    bitwarden
    chatterino2
    deploy-rs
    fd
    filelight
    firefox-wayland # Until firefox moves to using wayland by default
    foliate
    fzf
    gimp
    gocryptfs
    helvum
    heroic
    inkscape
    # itch # Currently using unsafe electron version
    kate
    kitty
    kolourpaint
    libreoffice-qt
    logseq
    mangohud
    megasync # Soon to be dropped once nas is fully operational
    mpv
    obs-studio
    obs-studio-plugins.obs-vkcapture
    prismlauncher-qt5
    protonup
    prusa-slicer
    qbittorrent
    quickemu
    retroarchFull
    rpcs3
    signal-desktop
    solvespace
    steam-run
    streamlink-twitch-gui-bin
    tdesktop
    thunderbird-wayland # Until thunderbird moves to using wayland by default
    ungoogled-chromium
    unrar
    vagrant
    ventoy-bin
    virt-manager
    yakuake
    # Package overrides
    (appimage-run.override {
      extraPkgs = pkgs: [  ];
    })
    # Packages from 3rd party overlays
    nur.repos.baduhai.koi
    nur.repos.baduhai.emulationstation-de
  ];

  programs = {
    adb.enable = true;
    steam.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
    partition-manager.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    fonts = with pkgs; [
      inter
      roboto
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
}
