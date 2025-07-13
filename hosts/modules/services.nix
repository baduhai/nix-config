{
  hostType,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      services = {
        tailscale = {
          enable = true;
          extraUpFlags = [ "--operator=user" ];
        };
        openssh = {
          enable = true;
          settings.PermitRootLogin = "no";
        };
        git-pull-timer = {
          enable = true;
          remoteAddresses = [
            "git@github.com:baduhai/nix-config.git"
            "https://github.com/baduhai/nix-config.git"
          ];
          user = "user";
          group = "users";
        };
        fwupd.enable = true;
        fstrim.enable = true;
      };
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
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
      };
    })
  ];
}
