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
      (blender.withPackages (p: [ python312Packages.py-slvs ]))
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
