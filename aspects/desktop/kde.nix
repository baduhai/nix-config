{ ... }:

{
  flake.modules = {
    nixos.kde =
      { pkgs, ... }:
      {
        services = {
          displayManager = {
            autoLogin = {
              enable = true;
              user = "user";
            };
            plasma-login-manager.enable = true;
          };
          desktopManager.plasma6.enable = true;
          pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
            wireplumber.enable = true;
          };
        };
        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
          extraPortals = with pkgs; [
            kdePackages.xdg-desktop-portal-kde
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
          ];
          config.common.default = "*";
        };
        programs.kdeconnect.enable = true;
      };

    homeManager.kde =
      { pkgs, ... }:
      {
      };
  };
}
