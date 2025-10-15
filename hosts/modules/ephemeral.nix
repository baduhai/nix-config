{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.self.nixosModules.ephemeral
  ];

  ephemeral = {
    enable = true;
    rootDevice = "/dev/mapper/cryptroot";
    rootSubvolume = "@root";
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
