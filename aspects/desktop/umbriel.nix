{ ... }:

{
  flake.modules = {
    nixos.umbriel =
      { inputs, pkgs, ... }:
      let
        # file-roller shells out to command-line tools for every format
        # libarchive cannot handle itself, and only finds them on $PATH. Cover
        # the full set of backends it ships (see src/fr-command-*.c): 7z, ar,
        # arj, cab, cpio, deb, lha, lrzip, lzop, rar, rpm, tar, xar, zip,
        # compress and the gzip/bzip2/xz/zstd family.
        archiveTools = with pkgs; [
          arj
          binutils # ar
          bzip2
          cabextract
          cpio
          dpkg # dpkg-deb, for .deb
          gnutar
          gzip
          lhasa # lha/lzh
          lzip
          lrzip
          lzop
          ncompress # .Z
          p7zip # 7z
          rpm # rpm2cpio, for .rpm
          unar
          unrar
          unshield # InstallShield .cab
          unzip
          xar
          xz
          zip
          zstd
        ];

        # Built against better-nautilus's own nixpkgs, which has the GLib
        # version Nautilus 51.0.1 requires.
        patchedNautilus =
          inputs.better-nautilus.packages.${pkgs.stdenv.hostPlatform.system}.nautilus;
      in
      {
        programs = {
          umbriel.enable = true;

          # Noctalia is the shell umbriel is designed around. umbriel.service
          # publishes umbriel-session.target (Type=notify) once the compositor
          # is ready, so the shell can hook that target directly instead of
          # mango's hand-written session target.
          noctalia = {
            enable = true;
            systemd = {
              enable = true;
              # Only start the shell with umbriel, so it does not also appear
              # in the mango session while both are enabled for testing.
              target = "umbriel-session.target";
            };
            recommendedServices.enable = true;
          };

          # Phone integration. The module installs kdeconnectd, opens TCP/UDP
          # 1714-1764 and enables uinput for the remote-input plugin.
          kdeconnect.enable = true;
        };

        # Noctalia's greeter bundles its own wlroots compositor, so unlike
        # the DMS greeter it does not need a separate sway session. greetd
        # starts it from a PAM-built environment, so XCURSOR_THEME from
        # environment.sessionVariables never reaches it; the cursor has to be
        # set in greeter.toml instead.
        services.displayManager.noctalia-greeter = {
          enable = true;
          # Breeze_Light is the directory that holds the theme's cursors/ in
          # kdePackages.breeze; the module adds its share/icons to the search
          # path. The size matches XCURSOR_SIZE for the session.
          cursorTheme = {
            name = "Breeze_Light";
            package = pkgs.kdePackages.breeze;
          };
          settings.cursor.size = 24;
        };

        environment = {
          # Cursor theme for Wayland/X11 clients; the compositor reads it from
          # its own config.
          sessionVariables = {
            XCURSOR_THEME = "Breeze_Light";
            XCURSOR_SIZE = "24";
          };

          systemPackages =
            with pkgs;
            [
              kdePackages.breeze # Breeze cursor theme (Breeze_Light)
              # KWallet: ksecretd (started below) serves
              # org.freedesktop.secrets on top of the KDE wallet - the store
              # the Nextcloud client already uses.
              kdePackages.kwallet
              adwaita-icon-theme # Adwaita icon theme for GTK/Qt apps
              morewaita-icon-theme # Adwaita-style extras (folder-games etc.)
              # GTK theming. adw-gtk3 gives apps an Adwaita-style GTK3 theme;
              # gsettings-desktop-schemas makes org.gnome.desktop.interface
              # resolvable for the settings portal and libadwaita apps.
              adw-gtk3
              gsettings-desktop-schemas
              rio
              ghostty
              # Noctalia's phone-connect plugin reads kdeconnect's device list
              # over DBus by shelling out to gdbus (glib). Without it on PATH the
              # panel opens but stays empty even when kdeconnect-cli sees the
              # phone, and the failure is silent.
              glib
              # ddcutil for external-monitor brightness/contrast (DDC/CI). It
              # needs /dev/i2c-* and write access to them, so hardware.i2c is
              # enabled below; the "i2c-dev" kernelParams entry in
              # aspects/systems/desktop.nix only reaches the kernel command
              # line and does not load the module.
              ddcutil
              # File picker for the phone-connect plugin: its pick_image /
              # pick_share actions shell out to kdialog, falling back to zenity,
              # and error out with "kdialog/zenity not found" when neither is on
              # PATH. It does not use the xdg portal picker.
              zenity
              # File manager + archive manager. Nautilus needs gvfs for trash,
              # network shares and phones, and udisks2 to mount removable media.
              patchedNautilus
              file-roller
              gvfs
              udisks2
            ]
            ++ archiveTools;
        };

        # ddcutil talks DDC/CI over i2c; this loads i2c-dev and lets seated
        # users open /dev/i2c-* (uaccess rule), which is what "ddcutil detect"
        # needs to see the monitor instead of failing with a permission error.
        hardware.i2c.enable = true;

        # The umbriel module's preferred config falls back to the plain GTK3
        # file chooser. GNOME's backend delegates FileChooser to Nautilus, so
        # routing it there uses the patched Nautilus UI (hjkl, / search,
        # sorting, sidebar) for open/save dialogs too.
        xdg.portal = {
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
          config.umbriel."org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
        };

        # Nextcloud (via QtKeychain/libsecret) keeps the account token in the
        # Secret Service. ksecretd translates org.freedesktop.secrets into the
        # kdewallet collection; umbriel's session starts it like any other
        # graphical-session service.
        systemd.user.services.ksecretd = {
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.kdePackages.kwallet}/bin/ksecretd";
            Restart = "on-failure";
          };
        };
      };
  };
}
