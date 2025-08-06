{ ... }:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/mmc-hDEaP3_0x1041b689";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1MiB";
              end = "1GiB";
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
            cryptroot = {
              priority = 3;
              name = "root";
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "subvol=@root"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "subvol=@home"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "subvol=@nix"
                      ];
                    };
                    "@persistent" = {
                      mountpoint = "/persistent";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "subvol=@persistent"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
