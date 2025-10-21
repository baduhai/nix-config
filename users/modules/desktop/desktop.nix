{
  config,
  inputs,
  pkgs,
  ...
}:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [ xwayland-satellite ];

  programs = {

    ghostty = {
      enable = true;
      settings = {
        cursor-style = "block";
        shell-integration-features = "no-cursor";
        cursor-style-blink = false;
        custom-shader = "${builtins.fetchurl {
          url = "https://raw.githubusercontent.com/hackr-sh/ghostty-shaders/cb6eb4b0d1a3101c869c62e458b25a826f9dcde3/cursor_blaze.glsl";
          sha256 = "sha256:0g2lgqjdrn3c51glry7x2z30y7ml0y61arl5ykmf4yj0p85s5f41";
        }}";
        bell-features = "border";
        gtk-titlebar-style = "tabs";
        keybind = [ "shift+enter=esc:\\x1b[13;2u" ];
      };
    };

    password-store = {
      enable = true;
      package = pkgs.pass-wayland;
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  xdg = {
    enable = true;
    userDirs.enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = {
        # Web browsing (priority: Junction > Zen > Brave > Tor)
        "text/html" = [
          "com.github.timecraft.junction.desktop"
          "zen-browser.desktop"
          "brave-browser.desktop"
          "torbrowser.desktop"
        ];
        "x-scheme-handler/http" = [
          "com.github.timecraft.junction.desktop"
          "zen-browser.desktop"
          "brave-browser.desktop"
          "torbrowser.desktop"
        ];
        "x-scheme-handler/https" = [
          "com.github.timecraft.junction.desktop"
          "zen-browser.desktop"
          "brave-browser.desktop"
          "torbrowser.desktop"
        ];
        "x-scheme-handler/about" = [
          "com.github.timecraft.junction.desktop"
          "zen-browser.desktop"
          "brave-browser.desktop"
          "torbrowser.desktop"
        ];
        "x-scheme-handler/unknown" = [
          "com.github.timecraft.junction.desktop"
          "zen-browser.desktop"
          "brave-browser.desktop"
          "torbrowser.desktop"
        ];

        # Images
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";

        # Video
        "video/mp4" = "io.bassi.Showtime.desktop";
        "video/x-matroska" = "io.bassi.Showtime.desktop";
        "video/webm" = "io.bassi.Showtime.desktop";
        "video/mpeg" = "io.bassi.Showtime.desktop";
        "video/x-msvideo" = "io.bassi.Showtime.desktop";
        "video/quicktime" = "io.bassi.Showtime.desktop";
        "video/x-flv" = "io.bassi.Showtime.desktop";

        # Audio
        "audio/mpeg" = "io.bassi.Showtime.desktop";
        "audio/flac" = "io.bassi.Showtime.desktop";
        "audio/ogg" = "io.bassi.Showtime.desktop";
        "audio/wav" = "io.bassi.Showtime.desktop";
        "audio/mp4" = "io.bassi.Showtime.desktop";
        "audio/x-opus+ogg" = "io.bassi.Showtime.desktop";

        # PDF and documents (priority: Papers > Zen Browser)
        "application/pdf" = [
          "org.gnome.Papers.desktop"
          "zen-browser.desktop"
        ];

        # Text files (Ghostty + Helix)
        "text/plain" = "Helix.desktop";
        "text/markdown" = "Helix.desktop";
        "text/x-log" = "Helix.desktop";
        "application/x-shellscript" = "Helix.desktop";

        # Office documents
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
          "onlyoffice-desktopeditors.desktop"; # DOCX
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
          "onlyoffice-desktopeditors.desktop"; # XLSX
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
          "onlyoffice-desktopeditors.desktop"; # PPTX
        "application/vnd.oasis.opendocument.text" = "onlyoffice-desktopeditors.desktop"; # ODT
        "application/vnd.oasis.opendocument.spreadsheet" = "onlyoffice-desktopeditors.desktop"; # ODS
        "application/vnd.oasis.opendocument.presentation" = "onlyoffice-desktopeditors.desktop"; # ODP
        "application/msword" = "onlyoffice-desktopeditors.desktop"; # DOC
        "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop"; # XLS
        "application/vnd.ms-powerpoint" = "onlyoffice-desktopeditors.desktop"; # PPT

        # Archives
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rar" = "org.gnome.FileRoller.desktop";
        "application/gzip" = "org.gnome.FileRoller.desktop";
        "application/x-bzip" = "org.gnome.FileRoller.desktop";

        # File manager
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
  };

  # Set Ghostty as default terminal
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };
}
