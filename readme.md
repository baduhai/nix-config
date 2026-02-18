# NixOS Flake Configuration

Modular NixOS configuration using flake-parts with the [dendritic](https://github.com/gytis-ivaskevicius/dendritic) pattern.

## Structure

```
.
├── aspects/           # Reusable NixOS/home-manager modules (dendritic)
│   ├── base/          # Base system configuration
│   ├── hosts/         # Host-specific configurations
│   │   ├── _alexandria/
│   │   ├── _io/
│   │   ├── _rotterdam/
│   │   └── _trantor/
│   ├── systems/       # System type modules (desktop, server, cli, gaming)
│   └── users/         # User account configurations
├── data/              # Shared host/service definitions
├── packages/          # Custom packages and overlays
├── shells/            # Shell configurations
└── terranix/          # Terraform configurations for cloud resources
```

## Hosts

| Host | Architecture | Type | Description |
|------|--------------|------|-------------|
| trantor | aarch64-linux | server | ARM server running Forgejo |
| alexandria | x86_64-linux | server | x86 server (Kanidm, Vaultwarden, Nextcloud, Jellyfin) |
| rotterdam | x86_64-linux | desktop | Gaming desktop with GPU passthrough |
| io | x86_64-linux | desktop | Workstation |

## Services

- **git.baduhai.dev** (Forgejo) - Publicly accessible on trantor

Other services (LAN/Tailscale only): Kanidm, Vaultwarden, Nextcloud, Jellyfin

## Features

- **Ephemeral root**: Automatic btrfs subvolume rollover with impermanence
- **Secrets**: Managed via agenix with age encryption
- **Disk management**: disko for declarative disk partitioning
- **Modular architecture**: Each aspect is a separate module imported via import-tree
- **Dendritic pattern**: Aspects are imported as a unified flake module

## Building

```bash
# Build specific host
nix build .#nixosConfigurations.trantor.config.system.build.toplevel

# Rebuild host (if using nixos-cli on the host)
sudo nixos apply
```

## Terranix

Terraform configurations for cloud infrastructure managed via terranix:

- baduhai.dev DNS
- Cloudflare tunnel endpoints
- Tailscale subnet routers

## Key Dependencies

- nixpkgs (nixos-unstable for workstations, nixos for servers)
- home-manager
- agenix
- disko
- impermanence
- nix-flatpak
- nixos-cli
