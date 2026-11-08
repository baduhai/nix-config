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
│   ├── systems/       # System type modules (base, desktop, server, cli, gaming)
│   └── users/         # User account configurations
├── data/              # Shared host/service definitions
├── packages/          # Custom packages and overlays
├── secrets/           # agenix-encrypted secrets
├── shells/            # Dev shells
└── terranix/          # Terraform configurations for cloud resources
```

## Hosts

| Host | Architecture | Type | Description |
|------|--------------|------|-------------|
| trantor | aarch64-linux | server | ARM server running Forgejo, Vaultwarden, Fusion and Pocket-ID; reverse proxy for Nextcloud |
| alexandria | x86_64-linux | server | x86 server (Nextcloud, Jellyfin, Unbound) |
| rotterdam | x86_64-linux | desktop | Main workstation for gaming (also runs AI, dev and VM aspects) |
| io | x86_64-linux | desktop | Workstation (dev, VMs, AI) |

## Services

Public services are exposed through trantor's nginx (DNS is pointed at trantor); Nextcloud runs in a container on alexandria and is proxied via trantor.

| Service | Domain | Host | Access |
|---------|--------|------|--------|
| Forgejo | git.baduhai.dev | trantor | Public |
| Vaultwarden | pass.baduhai.dev | trantor | Public |
| Pocket-ID (SSO) | auth.baduhai.dev | trantor | Public |
| Nextcloud | cloud.baduhai.dev | alexandria | Public |
| Jellyfin | jellyfin.baduhai.dev | alexandria | LAN/Tailscale |
| Fusion (RSS) | rss.baduhai.dev | trantor | LAN/Tailscale |

## Features

- **Ephemeral root**: Automatic btrfs subvolume rollover with impermanence
- **Secrets**: Managed via agenix with age encryption
- **Disk management**: disko for declarative disk partitioning
- **Modular architecture**: Each aspect is a separate module imported via import-tree
- **Dendritic pattern**: Aspects are imported as a unified flake module
- **Theming**: Stylix for consistent colorschemes across hosts

## Building

```bash
# Build specific host
nix build .#nixosConfigurations.trantor.config.system.build.toplevel

# Apply config on the host
nixos apply

# Apply home-manager on desktop hosts
hm apply
```

## Terranix

Terraform configurations for cloud infrastructure managed via terranix:

- baduhai.dev and kernelpanic.space DNS on Cloudflare
- VPS provisioning on OCI
- Tailscale tailnet configuration

## Key Dependencies

- nixpkgs (nixos-unstable default; nixos-26.05 for servers, nixos-26.05-small for the Nextcloud container)
- home-manager
- agenix
- disko
- impermanence
- nixos-cli
- nix-flatpak
- stylix
- terranix
