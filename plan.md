# Current structure:

```
 hosts
├──  alexandria
│   ├──  hardware-configuration.nix
│   ├──  jellyfin.nix
│   ├──  kanidm.nix
│   ├──  nextcloud.nix
│   ├──  nginx.nix
│   ├──  unbound.nix
│   └──  vaultwarden.nix
├──  io
│   ├──  boot.nix
│   ├──  disko.nix
│   ├──  hardware-configuration.nix
│   ├──  programs.nix
│   └──  services.nix
├──  modules
│   ├──  common
│   │   ├──  boot.nix
│   │   ├──  console.nix
│   │   ├──  firewall.nix
│   │   ├──  locale.nix
│   │   ├──  nix.nix
│   │   ├──  openssh.nix
│   │   ├──  programs.nix
│   │   ├──  security.nix
│   │   ├──  services.nix
│   │   ├──  tailscale.nix
│   │   └──  users.nix
│   ├──  desktop
│   │   ├──  boot.nix
│   │   ├──  desktop.nix
│   │   ├──  nix.nix
│   │   └──  services.nix
│   ├──  server
│   │   ├──  boot.nix
│   │   ├──  nix.nix
│   │   └──  tailscale.nix
│   ├──  ai.nix
│   ├──  bluetooth.nix
│   ├──  dev.nix
│   ├──  ephemeral.nix
│   ├──  fwupd.nix
│   ├──  gaming.nix
│   ├──  libvirtd.nix
│   ├──  networkmanager.nix
│   └──  podman.nix
├──  rotterdam
│   ├──  boot.nix
│   ├──  hardware-configuration.nix
│   ├──  hardware.nix
│   ├──  programs.nix
│   └──  services.nix
└──  trantor
    ├──  boot.nix
    ├──  disko.nix
    ├──  fail2ban.nix
    ├──  forgejo.nix
    ├──  hardware-configuration.nix
    ├──  networking.nix
    ├──  nginx.nix
    ├──  openssh.nix
    └──  unbound.nix
 modules
└──  ephemeral.nix
 users
├──  modules
│   ├──  common
│   │   ├──  bash.nix
│   │   ├──  fish.nix
│   │   └──  hm-cli.nix
│   ├──  desktop
│   │   ├──  desktop.nix
│   │   └──  niri.nix
│   ├──  btop.nix
│   ├──  comma.nix
│   ├──  direnv.nix
│   ├──  gaming.nix
│   ├──  helix.nix
│   ├──  obs-studio.nix
│   ├──  starship.nix
│   ├──  stylix.nix
│   └──  tmux.nix
└──  user
    └──  git.nix
```

