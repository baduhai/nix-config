# NixOS Configuration

A declarative, modular NixOS/Home Manager flake configuration managing multiple systems with a tag-based architecture for maximum code reuse and flexibility.

## Hosts

| Host | Type | System | Version | Description |
|------|------|--------|---------|-------------|
| **rotterdam** | Desktop | x86_64-linux | NixOS Unstable | Primary workstation with gaming, development |
| **io** | Laptop | x86_64-linux | NixOS Unstable | Mobile workstation |
| **alexandria** | Server/NAS | x86_64-linux | NixOS 25.05 | Personal server running Nextcloud, Forgejo, Jellyfin, Vaultwarden |
| **trantor** | VPS | aarch64-linux | NixOS 25.05 | Oracle Cloud instance |

## Key Features

### Architecture
- **Tag-based module system** - Compose configurations using tags instead of traditional inheritance
- **Flake-based** - Fully reproducible builds with locked dependencies
- **Multi-platform** - Supports both x86_64 and aarch64 architectures
- **Deployment automation** - Remote deployment via deploy-rs

### Desktop Experience
- **Niri compositor** - Custom fork with auto-centering window columns
- **Unified theming** - Stylix-based theming
- **Wayland-native** - Full Wayland support
- **Ephemeral root** - Impermanent filesystem using BTRFS for atomic rollback capability

### Self-Hosted Services
- **Nextcloud** - Cloud storage with calendar, contacts, and notes
- **Forgejo** - Self-hosted Git server
- **Jellyfin** - Media streaming
- **Vaultwarden** - Password manager backend
- **LibreSpeed** - Network speed testing
- All services behind Nginx and Tailscale with automatic SSL via Let's Encrypt

### Security
- **Agenix** - Encrypted secrets management
- **Tailscale** - Zero-config VPN mesh network
- **Firewall** - Configured on all hosts
- SSH key-based authentication

## Repository Structure

```
.
├── flake.nix                    # Main flake definition
├── utils.nix                    # Tag-based module system utilities
├── nixosConfigurations.nix      # Host definitions with tags
├── homeConfigurations.nix       # User configurations
├── deploy.nix                   # Remote deployment configuration
├── hosts/
│   ├── alexandria/              # Server-specific config
│   ├── io/                      # Laptop-specific config
│   ├── rotterdam/               # Desktop-specific config
│   ├── trantor/                 # VPS-specific config
│   └── modules/
│       ├── common/              # Shared base configuration
│       ├── desktop/             # Desktop environment setup
│       ├── server/              # Server-specific modules
│       └── [tag].nix            # Optional feature modules
├── users/
│   └── modules/                 # Home Manager configurations
│       └── [tag].nix            # Optional feature modules
├── packages/                    # Custom package definitions
└── secrets/                     # Encrypted secrets (agenix)
```

## Tag System

Configurations are composed using tags that map to modules:

**Common Tags** (all hosts):
- `common` - Base system configuration (automatically applied)

**General Tags**:
- `desktop` - *Mostly* full desktop environment with Niri WM
- `dev` - Development tools and environments
- `gaming` - Steam, Heroic, gamemode, controller support
- `ephemeral` - Impermanent root filesystem
- `networkmanager` - WiFi and network management
- `libvirtd` - KVM/QEMU virtualization
- `podman` - Container runtime
- `bluetooth` - Bluetooth support
- `fwupd` - Firmware update daemon

**Server Tags**:
- `server` - Server-specific configuration

## Usage

### Rebuilding a Configuration

```bash
# Local rebuild
sudo nixos-rebuild switch --flake .#hostname

# Remote deployment
deploy .#hostname
```

### Updating Dependencies

```bash
nix flake update
```

### Adding a New Host

1. Create host directory in `hosts/`
2. Define configuration in `nixosConfigurations.nix` with appropriate tags
3. Add deployment profile in `deploy.nix` if needed

## Dependencies

- [nixpkgs](https://github.com/NixOS/nixpkgs) - Stable (25.05) and unstable channels
- [home-manager](https://github.com/nix-community/home-manager) - User configuration
- [agenix](https://github.com/ryantm/agenix) - Secrets management
- [disko](https://github.com/nix-community/disko) - Declarative disk partitioning
- [stylix](https://github.com/danth/stylix) - System-wide theming
- [niri-flake](https://github.com/sodiboo/niri-flake) - Wayland compositor (custom fork)
- [impermanence](https://github.com/nix-community/impermanence) - Ephemeral filesystem support
- [deploy-rs](https://github.com/serokell/deploy-rs) - Remote deployment
- [nix-flatpak](https://github.com/gmodena/nix-flatpak) - Declarative Flatpak management
