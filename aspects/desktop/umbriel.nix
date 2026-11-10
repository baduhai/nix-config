{ ... }:

{
  flake.modules = {
    nixos.umbriel =
      {
        inputs,
        pkgs,
        config,
        ...
      }:
      let
        # file-roller shells out to command-line tools for every format
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
          p7zip
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

        betterNautilus = inputs.better-nautilus.packages.${pkgs.stdenv.hostPlatform.system}.nautilus;
      in
      {
        imports = [
          inputs.noctalia.nixosModules.default
          inputs.umbriel.nixosModules.default
        ];

        nix.settings = {
          extra-substituters = [
            "https://noctalia.cachix.org"
            "https://umbriel.cachix.org"
          ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
            "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
          ];
        };

        programs = {
          xwayland.enable = true;
          umbriel.enable = true;
          noctalia = {
            enable = true;
            systemd = {
              enable = true;
              target = "umbriel-session.target";
            };
            recommendedServices.enable = true;
          };
          kdeconnect.enable = true;
        };

        # Autologin: greetd runs this session before the greeter on boot, so
        # logging out drops back to noctalia-greeter instead of a dead TTY.
        services.greetd.settings.initial_session = {
          command = "${config.programs.umbriel.package}/bin/start-umbriel";
          user = "user";
        };

        services.displayManager.noctalia-greeter = {
          enable = true;
          cursorTheme = {
            name = "Breeze_Light";
            package = pkgs.kdePackages.breeze;
          };
          settings = {
            appearance.hide_logo = false;
            cursor.size = 24;
          };
        };
        environment.persistence.main.directories = [
          "/var/lib/noctalia-greeter"
        ];

        environment = {
          sessionVariables = {
            XCURSOR_THEME = "Breeze_Light";
            XCURSOR_SIZE = "24";
          };

          systemPackages =
            with pkgs;
            [
              kdePackages.breeze
              kdePackages.kwallet
              adwaita-icon-theme
              morewaita-icon-theme
              adw-gtk3
              gsettings-desktop-schemas
              ghostty
              # Resolves the XDG default terminal for `Terminal=true` launchers.
              xdg-terminal-exec
              glib
              ddcutil
              zenity
              betterNautilus
              file-roller
              gvfs
              udisks2
            ]
            ++ archiveTools;
        };

        hardware.i2c.enable = true;

        xdg.portal = {
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

          # Flatpak apps read their secrets through the Secret portal, which the
          # umbriel module leaves unset; nothing here implements it, so those
          # apps cannot store anything. KWallet's backend (`kwallet`, already
          # installed for Qt clients) does, and ksecretd backs it with the same
          # wallet the Nextcloud/Qt token lives in.
          config.umbriel = {
            "org.freedesktop.impl.portal.Secret" = [ "kwallet" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
          };
        };

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
