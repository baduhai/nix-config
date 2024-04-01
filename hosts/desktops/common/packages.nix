{ inputs, config, pkgs, lib, ... }:
let
  kdepkgs = with pkgs.kdePackages; [
    ark
    dolphin-plugins
    kaccounts-integration
    kaccounts-providers
    kate
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
      beeper
      deploy-rs
      distrobox
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
      kolourpaint
      libfido2
      libreoffice-qt
      mangohud
      mpv
      nextcloud-client
      nix-init
      obs-studio
      ocs-url
      octaveFull
      p7zip
      platformio
      prismlauncher-qt5
      protonup
      pulseaudio
      qalculate-qt
      qbittorrent
      quickemu
      qview
      ripgrep
      solvespace
      # space-cadet-pinball # Broken
      sparrow
      steam-run
      ungoogled-chromium
      unrar
      vagrant
      ventoy
      virt-manager
      yad
      wezterm
    ] ++ kdepkgs;

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
