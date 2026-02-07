# Ephemeral root aspect - provides automatic btrfs root subvolume rollover
# Exports both a base module with options and a factory function for easy configuration
{ inputs, ... }:
{
  # Base module with options (for external flakes or direct use)
  flake.modules.nixos.ephemeral = { lib, config, ... }:
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
          default = "@root";
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
            set -euo pipefail

            mkdir /btrfs_tmp
            if ! mount ${cfg.rootDevice} /btrfs_tmp; then
              echo "ERROR: Failed to mount ${cfg.rootDevice}"
              exit 1
            fi

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

            if ! btrfs subvolume create /btrfs_tmp/${cfg.rootSubvolume}; then
              echo "ERROR: Failed to create subvolume ${cfg.rootSubvolume}"
              umount /btrfs_tmp
              exit 1
            fi

            umount /btrfs_tmp
          '';
        };
      };
    };

  # Factory function that generates configured modules
  flake.factory.ephemeral =
    { rootDevice
    , rootSubvolume ? "@root"
    , retentionDays ? 30
    , persistentStoragePath ? "/persistent"
    , persistentFiles ? [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ]
    , persistentDirectories ? [
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"
        "/var/lib/bluetooth"
        "/var/lib/flatpak"
        "/var/lib/lxd"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/tailscale"
        "/var/log"
      ]
    }:
    { ... }: {
      imports = [
        inputs.impermanence.nixosModules.impermanence
        inputs.self.modules.nixos.ephemeral
      ];

      ephemeral = {
        enable = true;
        inherit rootDevice rootSubvolume;
        oldRootRetentionDays = retentionDays;
      };

      fileSystems."/persistent".neededForBoot = true;

      environment.persistence.main = {
        inherit persistentStoragePath;
        files = persistentFiles;
        directories = persistentDirectories;
      };
    };
}
