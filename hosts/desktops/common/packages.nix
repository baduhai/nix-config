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
    helvum
    # heroic # Currently using unsafe electron version
    inkscape
    # itch # Currently using unsafe electron version
    junction
    kate
    kolourpaint
    libfido2
    libreoffice-qt
    lutris
    mangohud
    mpv
    nextcloud-client
    nix-init
    obs-studio
    p7zip
    platformio
    prismlauncher-qt5
    protonup
    qbittorrent
    quickemu
    qview
    ripgrep
    solvespace
    space-cadet-pinball
    steam-run
    ungoogled-chromium
    unrar
    vagrant
    ventoy
    vial
    virt-manager
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
