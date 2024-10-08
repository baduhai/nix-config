{ pkgs, ... }:
let
  kdepkgs = with pkgs.kdePackages; [
    ark
    dolphin-plugins
    kolourpaint
    merkuro
    kdepim-addons
  ];
in
{
  environment.systemPackages =
    with pkgs;
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
      # lilipod
      mangohud
      microsoft-edge
      mission-center
      mpv
      nextcloud-client
      nixfmt-rfc-style
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
      qview
      ripgrep
      rnote
      solvespace
      space-cadet-pinball
      sparrow
      steam-run
      tor-browser
      ungoogled-chromium
      unrar
      ventoy
      virt-manager
      wezterm
    ]
    ++ kdepkgs;

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.tchx84.Flatseal"
      "com.steamgriddb.SGDBoop"
      "io.github.zen_browser.zen"
      "org.gtk.Gtk3theme.adw-gtk3"
      "org.gtk.Gtk3theme.adw-gtk3-dark"
    ];
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
      flake = "/home/user/Projects/personal/nix-config";
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      corefonts
      noto-fonts-cjk
      roboto
    ];
  };

  environment.plasma6.excludePackages = (
    with pkgs.kdePackages;
    [
      elisa
      gwenview
      khelpcenter
      konsole
      oxygen
    ]
  );
}
