{ inputs, config, pkgs, lib, ... }:
let
  kdepkgs = with pkgs.kdePackages; [
    ark
    discover
    dolphin-plugins
    kaccounts-integration
    kaccounts-providers
    kolourpaint
    merkuro
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
      clonehero
      deploy-rs
      distrobox
      fd
      filelight
      firefox
      fzf
      gimp
      heroic
      inkscape
      itch
      junction
      kde-rounded-corners
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
      orca-slicer
      openscad
      p7zip
      plasticity
      prismlauncher
      protonup
      qbittorrent
      ripgrep
      solvespace
      space-cadet-pinball
      sparrow
      steam-run
      ungoogled-chromium
      unrar
      ventoy
      virt-manager
      wezterm
    ] ++ kdepkgs;

  services.flatpak = {
    enable = true;
    packages = [ "com.github.flxzt.rnote" "com.github.tchx84.Flatseal" ];
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
    (with pkgs.kdePackages; [ elisa oxygen khelpcenter ]);
}
