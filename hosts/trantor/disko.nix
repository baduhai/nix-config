{ inputs, ... }:

{
  imports = [ inputs.disko.nixosModules.default ];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/scsi-360b207ed25d84372a95d1ecf842f8e20";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1MiB";
          end = "512MiB";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot/efi";
            mountOptions = [
              "noatime"
              "fmask=0077"
              "dmask=0077"
            ];
          };
        };
        root = {
          priority = 2;
          name = "root";
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "@root" = {
                mountpoint = "/";
                mountOptions = [
                  "noatime"
                  "compress=zstd"
                ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "noatime"
                  "compress=zstd"
                ];
              };
              "@persistent" = {
                mountpoint = "/persistent";
                mountOptions = [
                  "noatime"
                  "compress=zstd"
                ];
              };
            };
          };
        };
      };
    };
  };
}
