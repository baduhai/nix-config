{ inputs, config, pkgs, lib, ... }:

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
    firefox
    foliate
    fzf
    gimp
    gocryptfs
    helvum
    heroic
    inkscape
    # itch # Currently using unsafe electron version
    junction
    kate
    kolourpaint
    libfido2
    libreoffice-qt
    logseq
    lutris
    mangohud
    mpv
    nextcloud-client
    nix-init
    obs-studio
    p7zip
    platformio
    prismlauncher-qt5
    protontricks
    protonup
    qbittorrent
    quickemu
    qview
    gnome-solanum
    solvespace
    space-cadet-pinball
    steamtinkerlaunch
    steam-run
    tdesktop
    thunderbird
    ungoogled-chromium
    unrar
    vagrant
    ventoy
    virt-manager
    wezterm
    whatsapp-for-linux
    # Package overrides
    (appimage-run.override { extraPkgs = pkgs: [ libthai ]; })
    # Packages from 3rd party
    koi
  ];

  programs = {
    adb.enable = true;
    steam.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    kdeconnect.enable = true;
    partition-manager.enable = true;
    gamemode.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      inter
      roboto
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };

  environment.plasma5.excludePackages =
    (with pkgs.plasma5Packages; [ elisa gwenview oxygen khelpcenter konsole ]);
}
