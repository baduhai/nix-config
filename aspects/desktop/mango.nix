{ inputs, ... }:

{
  flake.modules = {
    nixos.mango =
      { pkgs, lib, ... }:
      let
        # glib searches $XDG_DATA_DIRS/glib-2.0/schemas, but Nix packages
        # install schemas under share/gsettings-schemas/<name>/glib-2.0/schemas.
        # Merge the ones the session needs into one compiled directory, so a
        # bare `gsettings` call (DMS shells out to it) resolves them without
        # any per-process environment.
        systemGsettingsSchemas =
          pkgs.runCommand "system-gsettings-schemas"
            {
              nativeBuildInputs = [ (lib.getDev pkgs.glib) ];
            }
            ''
              mkdir -p $out/share/glib-2.0/schemas
              for pkg in ${pkgs.gsettings-desktop-schemas} ${pkgs.gtk3}; do
                cp "$pkg"/share/gsettings-schemas/*/glib-2.0/schemas/*.xml $out/share/glib-2.0/schemas/
              done
              glib-compile-schemas $out/share/glib-2.0/schemas
            '';

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
      in
      {
        imports = [
          inputs.dms.nixosModules.dank-material-shell
          inputs.dank-greeter.nixosModules.default
        ];

        programs = {
          mango.enable = true;

          # The DMS greeter needs a compositor of its own (it can't reuse mango
          # from the login screen). Sway is the smallest of niri/hyprland/sway.
          # It only runs the greeter, so drop the nixpkgs default extraPackages
          # (foot, grim, brightnessctl, swayidle, swaylock, wmenu, pulseaudio).
          sway = {
            enable = true;
            extraPackages = [ ];
          };

          # Started by the exec_once line in the mango config, not by systemd.
          dank-material-shell = {
            enable = true;
            systemd.enable = false;
          };

          # Phone integration. The module installs kdeconnectd, opens TCP/UDP
          # 1714-1764 and enables uinput for the remote-input plugin.
          kdeconnect.enable = true;
        };

        environment.systemPackages =
          with pkgs;
          [
            kdePackages.breeze # Breeze cursor theme (breeze_cursors)
            # KWallet: the session starts ksecretd (see below), which serves
            # org.freedesktop.secrets on top of the KDE wallet - the store the
            # Nextcloud client already used while running Plasma.
            kdePackages.kwallet
            adwaita-icon-theme # Adwaita icon theme for GTK/Qt apps
            morewaita-icon-theme # Adwaita-style extras (folder-games etc.)
            # GTK theming for DMS. adw-gtk3 gives DMS a writable copy to patch
            # with dank-colors.css; gsettings-desktop-schemas makes
            # org.gnome.desktop.interface resolvable for DMS's gsettings calls
            # and the settings portal (libadwaita apps, browsers).
            adw-gtk3
            gsettings-desktop-schemas
            systemGsettingsSchemas
            rio
            # File manager + archive manager. Nautilus needs gvfs for trash,
            # network shares and phones, and udisks2 to mount removable media.
            nautilus
            file-roller
            gvfs
            udisks2
          ]
          ++ archiveTools;

        # Publish the merged schema directory from systemGsettingsSchemas.
        environment.pathsToLink = [ "/share/glib-2.0/schemas" ];

        # The session is started by greetd + mango, not by systemd, so nothing
        # pulls in graphical-session.target. Without it xdg-desktop-portal
        # refuses to start (Requisite=graphical-session.target in its unit),
        # libadwaita never learns the colour scheme, and services that want
        # the target (xdg-desktop-portal, ...) never autostart. Starting this
        # target from the compositor pulls the real one in as a dependency.
        systemd.user.targets.mango-session = {
          description = "Mango session";
          bindsTo = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
        };

        # Cursor theme for Wayland/X11 clients; the compositor picks it up from
        # its own config below.
        environment.sessionVariables = {
          XCURSOR_THEME = "Breeze_Light";
          XCURSOR_SIZE = "24";
        };

        # mango's nixpkgs module does not enable polkit; DMS needs it for
        # lock/reboot/logout actions.
        security.polkit.enable = true;

        # Nextcloud (via QtKeychain/libsecret) keeps the account token in the
        # Secret Service. Plasma serves that from KWallet: ksecretd translates
        # org.freedesktop.secrets into the kdewallet collection. A bare mango
        # session starts neither, so the client had nowhere to store the token
        # and asked for the password again on every boot. Plasma autostarts
        # ksecretd from its session; mango has to pull it in explicitly.
        systemd.user.services.ksecretd = {
          wantedBy = [ "mango-session.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.kdePackages.kwallet}/bin/ksecretd";
            Restart = "on-failure";
          };
        };

        xdg.portal = {
          # File dialogs: the mango module leaves FileChooser unset, so it
          # falls through to the `gtk` default - a plain GTK3 list view with no
          # search, recents or thumbnails. GNOME's backend ships the Nautilus-
          # style GTK4 picker; point the interface at it explicitly.
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

          # Flatpak apps read their secrets through the portal, which the mango
          # module points at gnome-keyring. Use KWallet's implementation instead;
          # ksecretd ships it, and gnome-keyring is not installed here.
          config.mango = {
            "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "kwallet" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
          };
        };

        services.displayManager = {
          # Auto-login (from aspects/desktop) resolves to this session, so mango
          # starts directly and the greeter shows up on logout.
          defaultSession = "mango";
        };

        programs.dms-greeter = {
          enable = true;
          compositor = {
            name = "sway";
            # greetd runs the greeter with a PAM-built environment, so the
            # systemd unit's environment (and XCURSOR_THEME) never reaches
            # sway. Set the cursor in the compositor config itself.
            customConfig = ''
              seat seat0 xcursor_theme Breeze_Light 24
            '';
          };
          configHome = "/home/user";
          logs.save = true;
        };
      };
  };
}
