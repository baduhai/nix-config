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
      fzf
      ghostty
      gnome-tweaks
      libfido2
      # lilipod BROKEN
      mangohud
      mission-center
      nixfmt-rfc-style
      nix-init
      nix-output-monitor
      ocs-url
      # orca-slicer BROKEN
      p7zip
      plasticity
      protonup
      # quickgui BROKEN
      ripgrep
      sparrow
      unrar
      ventoy
      wezterm
    ]
    ++ kdepkgs;

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.flxzt.rnote"
      "com.github.k4zmu2a.spacecadetpinball"
      "com.heroicgameslauncher.hgl"
      "com.mattjakeman.ExtensionManager"
      "com.microsoft.Edge"
      "com.modrinth.ModrinthApp"
      "com.nextcloud.desktopclient.nextcloud"
      "com.obsproject.Studio"
      "com.steamgriddb.SGDBoop"
      "dev.vencord.Vesktop"
      "io.github.giantpinkrobots.varia"
      "io.github.ungoogled_software.ungoogled_chromium"
      "io.github.zen_browser.zen"
      "io.itch.itch"
      "md.obsidian.Obsidian"
      "org.gimp.GIMP"
      "org.gnome.Showtime"
      "org.inkscape.Inkscape"
      "org.kde.krita"
      "org.libreoffice.LibreOffice"
      "org.mozilla.firefox"
      "org.torproject.torbrowser-launcher"
      "re.sonny.Junction"
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
      oxygen
    ]
  );
}
