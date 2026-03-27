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
            junction
            libfido2
            mission-center
            toggleaudiosink
            unrar
          ];
        };

        services = {
          printing.enable = true;
          udev.packages = with pkgs; [ yubikey-personalization ];
          keyd = {
            enable = true;
            keyboards = {
              all = {
                ids = [ "*" ];
                settings.main.capslock = "overload(meta, esc)";
              };
              corne = {
                ids = [ "5653:0001" ];
                settings.main = {
                  esc = "overload(meta, esc)";
                };
              };
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
          displayManager.autoLogin = {
            enable = true;
            user = "user";
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

        programs = {
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
        imports = [
          inputs.vicinae.homeManagerModules.default
        ]
        ++ (with inputs.self.modules.homeManager; [ media ]);

        fonts.fontconfig.enable = true;

        services.vicinae = {
          enable = true;
          systemd = {
            enable = true;
            autoStart = true;
          };
        };

        xdg = {
          enable = true;
          userDirs.enable = true;
        };
      };
  };
}
