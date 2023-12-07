{ config, lib, pkgs, ... }:

{
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
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/nixos"
      "/var/lib/flatpak"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    users.user = {
      directories = [
        "Documents"
        "Games"
        "Music"
        "Pictures"
        "Projects"
        "Videos"
        "VMs"
        ".mozilla"
        ".local/share/containers"
        ".local/share/direnv"
        ".local/share/flatpak"
        ".local/share/Steam"
        ".cache/nix"
        ".cache/flatpak"
      ];
    };
  };
}
