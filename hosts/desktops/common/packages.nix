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
    element-desktop-wayland
    fd
    filelight
    firefox
    floorp
    foliate
    fzf
    gamescope
    gimp
    helvum
    heroic
    inkscape
    # itch # Currently using unsafe electron version
    junction
    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.kate
    kdePackages.merkuro
    kolourpaint
    libfido2
    libreoffice-qt
    lutris
    mangohud
    mpv
    nextcloud-client
    nix-init
    obs-studio
    ocs-url
    p7zip
    platformio
    prismlauncher-qt5
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
    ungoogled-chromium
    unrar
    vagrant
    ventoy
    vial
    virt-manager
    yad
    wezterm
    # Package overrides
    (appimage-run.override { extraPkgs = pkgs: [ libthai ]; })
  ];

  programs = {
    adb.enable = true;
    steam.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    kdeconnect.enable = true;
    partition-manager.enable = true;
    gamemode.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      inter
      roboto
      maple-mono
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };

  environment.plasma6.excludePackages =
    (with pkgs.kdePackages; [ elisa gwenview oxygen khelpcenter konsole ]);
}
