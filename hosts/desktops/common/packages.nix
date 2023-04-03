{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    ark
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.pt_BR
    bat
    bitwarden
    deploy-rs
    distrobox
    fd
    filelight
    firefox-wayland # Until firefox moves to using wayland by default
    foliate
    fzf
    gimp
    gocryptfs
#     helvum
    heroic
    inkscape
#     itch # Currently using unsafe electron version
    jellyfin-media-player
    junction
    kolourpaint
    libfido2
    libreoffice-qt
    lite-xl
    logseq
    mangohud
    mpv
    nil
    nixfmt
    nix-init
    nix-your-shell
    obs-studio
    obs-studio-plugins.obs-vkcapture
    p7zip
    prismlauncher-qt5
    protontricks
    protonup
#     prusa-slicer
    qbittorrent
    quickemu
    qview
    signal-desktop
    solvespace
    space-cadet-pinball
    spotify
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
    yubikey-personalization-gui
    # Package overrides
    (appimage-run.override {
      extraPkgs = pkgs: [ libthai ];
    })
    # Packages from 3rd party overlays
    agenix
    chatterino7
    koi
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

  environment.plasma5.excludePackages = ( with pkgs.plasma5Packages; [
    elisa
    gwenview
    oxygen
    khelpcenter
    konsole
  ]);
}
