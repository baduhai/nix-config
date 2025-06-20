{
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
      mount /dev/disk/by-uuid/3287dbc3-c0fa-4096-a0b3-59b017cfecc8 /btrfs_tmp

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
}
