{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.niri-flake.nixosModules.niri
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  environment = {
    sessionVariables = {
      KDEHOME = "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
      NIXOS_OZONE_WL = "1"; # Forces chromium and most electron apps to run in wayland
    };
    systemPackages = with pkgs; [
      ### Web ###
      bitwarden-desktop
      brave
      nextcloud-client
      tor-browser
      qbittorrent
      vesktop
      inputs.zen-browser.packages."${system}".default
      ### Office & Productivity ###
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.pt_BR
      libreoffice
      onlyoffice-desktopeditors
      papers
      rnote
      ### Graphics & Design ###
      gimp
      inkscape
      loupe
      plasticity
      ### System Utilities ###
      adwaita-icon-theme
      better-control
      ghostty
      gnome-disk-utility
      junction
      libfido2
      mission-center
      nautilus
      p7zip
      rclone
      toggleaudiosink
      unrar
      ### Media ###
      mpv
      obs-studio
      qview
    ];
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
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --remember --asterisks --cmd ${config.programs.niri.package}/bin/niri-session";
          user = "greeter";
        };
        initial_session = {
          command = "${config.programs.niri.package}/bin/niri-session";
          user = "user";
        };
      };
    };
    flatpak = {
      enable = true;
      packages = [
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
    gvfs.enable = true;
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
    niri = {
      enable = true;
      package = inputs.niri.packages.${pkgs.system}.niri;
    };
    dconf.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  niri-flake.cache.enable = false;

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
