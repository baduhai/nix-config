# Nix Configuration

My personal Nix configuration for multiple NixOS hosts, home-manager users, miscellaneous resources... too many things to list. If I could put my life in a flake I would.

## Hosts

### Desktop Systems
- **rotterdam** - Main desktop workstation (x86_64)
  - Features: Desktop, AI tools, Bluetooth, Dev environment, Gaming, Virtualization (libvirtd), Podman
  - Storage: Ephemeral root with LUKS encryption

- **io** - Laptop workstation (x86_64)
  - Features: Desktop, AI tools, Bluetooth, Dev environment, Podman
  - Storage: Ephemeral root with LUKS encryption

### Servers
- **alexandria** - Home server (x86_64)
  - Hosts: Nextcloud, Vaultwarden, Jellyfin, Kanidm

- **trantor** - Cloud server (aarch64)
  - Hosts: Forgejo
  - Cloud provider: Oracle Cloud Infrastructure
  - Storage: Ephemeral root with btrfs

## Home Manager Configurations

- **user@rotterdam** - Full desktop setup with gaming, OBS, and complete development environment
- **user@io** - Lightweight desktop setup

Both configurations include:
- btop, direnv, helix, starship, tmux
- Stylix theme management
- Fish shell with custom configurations

## Terranix Configurations

Infrastructure as code using Terranix (NixOS + Terraform/OpenTofu):

- **oci-trantor** - Oracle Cloud Infrastructure provisioning for Trantor server
- **cloudflare-baduhaidev** - DNS and CDN configuration for baduhai.dev domain
- **tailscale-tailnet** - Tailscale network ACL and device management

## Services

All services are accessible via custom domains under baduhai.dev:

- **Kanidm** (auth.baduhai.dev) - Identity and access management
- **Vaultwarden** (pass.baduhai.dev) - Password manager
- **Forgejo** (git.baduhai.dev) - Git forge (publicly accessible)
- **Nextcloud** (cloud.baduhai.dev) - File sync and collaboration
- **Jellyfin** (jellyfin.baduhai.dev) - Media server

Services are accessible via:
- LAN for alexandria-hosted services
- Tailscale VPN for all services
- Public internet for Forgejo only

## Notable Features

### Ephemeral Root
Rotterdam, io, and trantor use an ephemeral root filesystem that resets on every boot:
- Root filesystem is automatically rolled back using btrfs snapshots
- Old snapshots retained for 30 days
- Persistent data stored in dedicated subvolumes
- Implements truly stateless systems

### Custom DNS Architecture
- Unbound DNS servers on both alexandria and trantor
- Service routing based on visibility flags (public/LAN/Tailscale)
- Split-horizon DNS for optimal access paths

### Security
- LUKS full-disk encryption on desktop systems
- Fail2ban on public-facing servers
- agenix for secrets management
- Tailscale for secure remote access

### Desktop Environment
- Custom Niri window manager (Wayland compositor)
- Using forked version with auto-centering feature
- Stylix for consistent theming

### Development Setup
- Nix flakes for reproducible builds
- deploy-rs for automated deployments
- Podman for containerization
- Complete AI tooling integration
