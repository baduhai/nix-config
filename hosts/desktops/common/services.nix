{ specialArgs, inputs, config, pkgs, lib, ... }:

let
  plasma = pkgs.writeScriptBin "plasma" ''
    ${pkgs.plasma-workspace}/bin/startplasma-wayland &> /dev/null
  '';
in

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
        default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --user-menu --asterisks --time --greeting \"Welcome to NixOS\" --cmd ${plasma}/bin/plasma";
        initial_session = {
          command = "${plasma}/bin/plasma";
          user = "user";
        };
      };
    };
  };
}
