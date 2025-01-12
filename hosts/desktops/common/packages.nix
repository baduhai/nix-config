{ inputs, pkgs, ... }:
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
      exhibit
      fd
      filelight
      firefox
      fzf
      ghostty
      gimp
      heroic
      inkscape
      junction
      kde-rounded-corners
      krita
      libfido2
      libreoffice-qt
      # lilipod BROKEN
      mangohud
      microsoft-edge
      mission-center
      mpv
      nextcloud-client
      nixfmt-rfc-style
      nix-init
      nix-output-monitor
      obsidian
      obs-studio
      ocs-url
      # orca-slicer BROKEN
      p7zip
      plasticity
      protonup
      # quickgui BROKEN
      qview
      ripgrep
      rnote
      solvespace
      sparrow
      steam-run
      tor-browser
      transmission_4-qt6
      ungoogled-chromium
      unrar
      ventoy
      vesktop
      wezterm
    ]
    ++ kdepkgs;

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.k4zmu2a.spacecadetpinball"
      "com.github.tchx84.Flatseal"
      "com.modrinth.ModrinthApp"
      "com.steamgriddb.SGDBoop"
      "io.github.zen_browser.zen"
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
      elisa
      gwenview
      khelpcenter
      konsole
      oxygen
    ]
  );
}
