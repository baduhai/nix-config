{
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.desktop =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ]
        ++ (with inputs.self.modules.nixos; [
          graphics
          media
          office
          web
        ]);

        boot = {
          plymouth.enable = true;
          initrd.systemd.enable = true;
          loader.efi.efiSysMountPoint = "/boot/efi";
          kernelPackages = pkgs.linuxPackages_xanmod_latest;
          extraModprobeConfig = ''
            options bluetooth disable_ertm=1
          '';
          kernel.sysctl = {
            "net.ipv4.tcp_mtu_probing" = 1;
          };
          kernelParams = [
            "quiet"
            "splash"
            "i2c-dev"
            "i2c-piix4"
            "loglevel=3"
            "udev.log_priority=3"
            "rd.udev.log_level=3"
            "rd.systemd.show_status=false"
          ];
        };

        nix = {
          registry.nixpkgs.flake = inputs.nixpkgs;
          nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
            "/nix/var/nix/profiles/per-user/root/channels"
          ];
        };

        environment = {
          etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
          sessionVariables = {
            KDEHOME = "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
            NIXOS_OZONE_WL = "1"; # Forces chromium and most electron apps to run in wayland
          };
          systemPackages = with pkgs; [
            adwaita-icon-theme
            ghostty
            gnome-disk-utility
            junction
            libfido2
            mission-center
            nautilus
            toggleaudiosink
            unrar
          ];
        };

        services = {
          printing.enable = true;
          udev.packages = with pkgs; [ yubikey-personalization ];
          keyd = {
            enable = true;
            keyboards.all = {
              ids = [ "*" ];
              settings.main.capslock = "overload(meta, esc)";
            };
          };
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
            settings.default_session.user = "greeter";
          };
          flatpak = {
            enable = true;
            packages = [
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
          kdeconnect = {
            enable = true;
            package = pkgs.valent;
          };
          dconf.enable = true;
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

        xdg.portal = {
          extraPortals = with pkgs; [
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
          config.common.default = "*";
        };
      };

    homeManager.desktop =
      {
        config,
        lib,
        pkgs,
        inputs,
        ...
      }:
      {
        imports = [ inputs.vicinae.homeManagerModules.default ];

        fonts.fontconfig.enable = true;

        home = {
          packages = with pkgs; [ xwayland-satellite ];
          sessionVariables.TERMINAL = "ghostty";
        };

        services.vicinae = {
          enable = true;
          systemd = {
            enable = true;
            autoStart = true;
          };
        };

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
              bell-features = "";
              gtk-titlebar-style = "tabs";
              keybind = [ "shift+enter=text:\\x1b\\r" ];
            };
          };

          password-store = {
            enable = true;
            package = pkgs.pass-wayland;
          };
        };

        xdg = {
          enable = true;
          userDirs.enable = true;
        };
      };
  };
}
