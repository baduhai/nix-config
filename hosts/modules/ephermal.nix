{ inputs, ... }:

{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

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
      mount /dev/mapper/cryptroot /btrfs_tmp

      if [[ -e /btrfs_tmp/@root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/@root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
           delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/@root
      umount /btrfs_tmp
    '';
  };

  environment.persistence.main = {
    persistentStoragePath = "/persistent";
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    directories = [
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
    ];
  };
}
