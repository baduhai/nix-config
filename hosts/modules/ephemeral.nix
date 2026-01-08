{ config, inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.self.nixosModules.ephemeral
  ];

  ephemeral = {
    enable = true;
    rootDevice =
      if config.networking.hostName == "trantor" then
        "/dev/disk/by-id/scsi-360b207ed25d84372a95d1ecf842f8e20-part2"
      else
        "/dev/mapper/cryptroot";
    rootSubvolume = "@root";
  };

  fileSystems."/persistent".neededForBoot = true;

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
