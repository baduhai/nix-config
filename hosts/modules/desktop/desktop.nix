{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  kwrite = pkgs.symlinkJoin {
    name = "kwrite";
    paths = [ pkgs.kdePackages.kate ];
    postBuild = ''
      rm -rf $out/bin/kate \
             $out/bin/.kate-wrapped \
             $out/share/applications/org.kde.kate.desktop \
             $out/share/man \
             $out/share/icons/hicolor/*/apps/kate.png \
             $out/share/icons/hicolor/scalable/apps/kate.svg \
             $out/share/appdata/org.kde.kate.appdata.xml
    '';
  };
in
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  environment = {
    sessionVariables = {
      KDEHOME = "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
      NIXOS_OZONE_WL = "1"; # Forces chromium and most electron apps to run in wayland
    };
    systemPackages =
      with pkgs;
      [
        ### Web ###
        bitwarden-desktop
        brave
        tor-browser
        qbittorrent
        vesktop
        ### Office & Productivity ###
        aspell
        aspellDicts.de
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.pt_BR
        kwrite
        libreoffice-qt
        onlyoffice-desktopeditors
        rnote
        ### Graphics & Design ###
        gimp
        inkscape
        plasticity
        ### System Utilities ###
        adwaita-icon-theme
        colloid-gtk-theme
        junction
        kara
        kde-rounded-corners
        libfido2
        mission-center
        p7zip
        rclone
        toggleaudiosink
        unrar
        ### Media ###
        mpv
        obs-studio
        qview
      ]
      ++ (with pkgs.kdePackages; [
        ark
        dolphin
        dolphin-plugins
        kolourpaint
      ]);
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --time --remember --asterisks --cmd ${lib.getExe pkgs.niri}";
        user = "greeter";
      };
    };
    flatpak = {
      enable = true;
      packages = [
        ### Internet Browsers & Communication ###
        "app.zen_browser.zen"
        ### Graphics & Design ###
        "com.boxy_svg.BoxySVG"
        rec {
          appId = "io.github.softfever.OrcaSlicer";
          sha256 = "0hdx5sg6fknj1pfnfxvlfwb5h6y1vjr6fyajbsnjph5gkp97c6p1";
          bundle = "${pkgs.fetchurl {
            url = "https://github.com/SoftFever/OrcaSlicer/releases/download/v2.3.0/OrcaSlicer-Linux-flatpak_V2.3.0_x86_64.flatpak";
            inherit sha256;
          }}";
        }
        ### System Utilities ###
        "com.github.tchx84.Flatseal"
        "com.rustdesk.RustDesk"
      ];
      uninstallUnmanaged = true;
      update.auto.enable = true;
    };
  };

  security.rtkit.enable = true; # Needed for pipewire to acquire realtime priority

  users = {
    users.greeter = {
      isSystemUser = true;
      group = "greeter";
    };
    groups.greeter = { };
  };

  programs = {
    niri.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
    partition-manager.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      corefonts
      inter
      nerd-fonts.fira-code
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
    ];
  };
}
