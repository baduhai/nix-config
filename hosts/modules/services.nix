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
        nixos-cli = {
          enable = true;
          config = {
            use_nvd = true;
            ignore_dirty_tree = true;
          };
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
