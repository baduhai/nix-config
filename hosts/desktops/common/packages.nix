{ inputs, pkgs, ... }:
let
  kdepkgs = with pkgs.kdePackages; [
    ark
    dolphin-plugins
    kolourpaint
  ];
in
{
  environment.systemPackages =
    with pkgs;
    [
      adwaita-icon-theme
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.pt_BR
      bat
      bitwarden-desktop
      clonehero
      deploy-rs
      distrobox
      fd
      firefox
      freecad-wayland
      fzf
      ghostty
      gimp
      heroic
      inkscape
      junction
      kara
      kde-rounded-corners
      libfido2
      libreoffice-qt
      # lilipod BROKEN
      mangohud
      microsoft-edge
      mission-center
      mpv
      nextcloud-client
      nixfmt-rfc-style
      nixos-firewall-tool
      nix-init
      nix-output-monitor
      obsidian
      obs-studio
      orca-slicer
      p7zip
      plasma-panel-colorizer
      plasticity
      protonup
      quickemu
      quickgui
      qview
      qbittorrent
      ripgrep
      rnote
      steam-run
      tor-browser
      ungoogled-chromium
      unrar
      ventoy
      vesktop
    ]
    ++ kdepkgs;

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.k4zmu2a.spacecadetpinball"
      "com.github.tchx84.Flatseal"
      "com.modrinth.ModrinthApp"
      "com.steamgriddb.SGDBoop"
      "app.zen_browser.zen"
      "io.itch.itch"
      "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
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
      noto-fonts-cjk-sans
      roboto
    ];
  };

  environment.plasma6.excludePackages = (
    with pkgs.kdePackages;
    [
      discover
      elisa
      gwenview
      kate
      khelpcenter
      konsole
      oxygen
    ]
  );
}
