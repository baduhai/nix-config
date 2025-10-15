{ lib, config, ... }:

let
  cfg = config.ephemeral;
in
{
  options.ephemeral = {
    enable = lib.mkEnableOption "ephemeral root with automatic rollback";

    rootDevice = lib.mkOption {
      type = lib.types.str;
      example = "/dev/mapper/cryptroot";
      description = "Device path for the root btrfs filesystem";
    };

    rootSubvolume = lib.mkOption {
      type = lib.types.str;
      example = "@root";
      description = "Name of the root btrfs subvolume";
    };

    oldRootRetentionDays = lib.mkOption {
      type = lib.types.int;
      default = 30;
      description = "Number of days to keep old root snapshots before deletion";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd.services.recreate-root = {
      description = "Rolling over and creating new filesystem root";
      requires = [ "initrd-root-device.target" ];
      after = [
        "local-fs-pre.target"
        "initrd-root-device.target"
      ];
      requiredBy = [ "initrd-root-fs.target" ];
      before = [ "sysroot.mount" ];
      unitConfig = {
        AssertPathExists = "/etc/initrd-release";
        DefaultDependencies = false;
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        mkdir /btrfs_tmp
        mount ${cfg.rootDevice} /btrfs_tmp

        if [[ -e /btrfs_tmp/${cfg.rootSubvolume} ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/${cfg.rootSubvolume})" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/${cfg.rootSubvolume} "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
             delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${toString cfg.oldRootRetentionDays}); do
          delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/${cfg.rootSubvolume}
        umount /btrfs_tmp
      '';
    };
  };
}
