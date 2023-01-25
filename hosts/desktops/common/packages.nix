{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    arduino
    ark
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.pt_BR
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
    kolourpaint
    libreoffice-qt
    logseq
    mangohud
    mpv
    obs-studio
    obs-studio-plugins.obs-vkcapture
    p7zip
    prismlauncher-qt5
    protonup
#     prusa-slicer
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
    wezterm
    yakuake
    # Package overrides
    (appimage-run.override {
      extraPkgs = pkgs: [  ];
    })
    # Packages from 3rd party overlays
    agenix
    nur.repos.baduhai.koi
    nur.repos.baduhai.emulationstation-de
  ];

  programs = {
    adb.enable = true;
    steam.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
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
