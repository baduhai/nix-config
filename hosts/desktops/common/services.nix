{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    xserver = {
      enable = false;
      autorun = false;
      layout = "us";
      xkbVariant = "altgr-intl";
      excludePackages = ( with pkgs; [ xterm ]);
      desktopManager.plasma5 = {
        enable     = true;
        excludePackages = ( with pkgs.plasma5Packages; [ elisa oxygen khelpcenter ]);
      };
#       displayManager = {
#         defaultSession = "plasmawayland";
#         sddm = {
#           enable = true;
#           autoNumlock = true;
#           settings = {
#             Theme = {
#               CursorTheme = "breeze_cursors";
#             };
#             X11 = {
#               UserAuthFile = ".local/share/sddm/Xauthority";
#             };
#           };
#         };
#       };
    };
    greetd = {
      enable = true;
      settings = {
        default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember  --asterisks --time --greeting \"Welcome to Nix\" --cmd ${pkgs.plasma-workspace}/bin/startplasma-wayland";
#         initial_session = {
#           command = "${pkgs.plasma-workspace}/bin/startplasma-wayland";
#           user = "user";
#         };
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    startplasma-wayland
    fish
  '';
}
