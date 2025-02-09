{
  inputs,
  pkgs,
  ...
}:

{
  services = {
    printing.enable = true;
    udev.packages = with pkgs; [ yubikey-personalization ];
    displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
    desktopManager.plasma6.enable = true;
    tailscale.useRoutingFeatures = "client";
    nginx = {
      enable = true;
      virtualHosts."localhost".root = inputs.homepage;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    # greetd = {
    #   enable = true;
    #   settings = {
    #     default_session.command =
    #       let
    #         xSessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions";
    #         wlSessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
    #       in
    #       ''
    #         ${pkgs.greetd.tuigreet}/bin/tuigreet \
    #         --remember \
    #         --asterisks \
    #         --time \
    #         --greeting "NixOS" \
    #         --sessions ${xSessions}:${wlSessions}
    #       '';
    #     initial_session = {
    #       command = ''
    #         ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland &> /dev/null
    #       '';
    #       user = "user";
    #     };
    #   };
    # };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
}
