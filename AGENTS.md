# AGENTS.md

NixOS + home-manager flake in `/etc/nixos`, using flake-parts + import-tree
(dendritic pattern). Hosts: trantor (aarch64 server), alexandria (x86 server),
rotterdam / io (x86 desktops).

## Human readability
This repo must stay human-readable. One concern per file, clear names, small
focused aspects, and comments that explain intent ("why", not "what"). Prefer
existing patterns over clever abstractions.

## Applying configs
- NixOS hosts: `nixos apply`. Aliases: `nixos build`, `nixos switch`,
  `nixos test`, `nixos boot`, `nixos dry-build`.
- Home-manager: `hm apply` (wraps `home-manager switch --flake /etc/nixos#user@host -b bkp`).
  Also `hm generation list | rollback | cleanup | switch <id> | delete <id>`.
- Both binaries come from this flake (`programs.nixos-cli`, `packages.hm-cli`);
  do not call `nixos-rebuild` / `home-manager switch` directly.

### Always disable nom in agent commands
`apply.use_nom = true` is set for human-friendly build output (see
`aspects/base/nix.nix`), but `nix-output-monitor` output is hard for agents to
parse. Agents MUST pass the config override on every invocation:

```bash
nixos apply --yes --config apply.use_nom=false
nixos build --config apply.use_nom=false
```

`--config` is the only supported override (no env var controls `apply.use_nom`);
it works before or after the subcommand and with all aliases. Never edit the
config to turn nom off globally.

### Cleaning up generations
- NixOS: `nixos generation list` (alias `nixos list-generations`), then
  `nixos generation rollback` or `nixos generation switch <gen>` to move.
  Prune with `nixos generation delete` (`--all` keeps the current generation,
  `--older-than 30d`, `--min N`, or explicit generation numbers).
- Home-manager: `hm generation list | rollback | switch <id> | delete <id>`, and
  `hm generation cleanup` (deletes all but the current generation).

## Layout
- `aspects/**`: expose `flake.modules.nixos.<name>` and/or `flake.modules.homeManager.<name>`.
- `aspects/hosts/<host>.nix`: host entrypoint; calls `inputs.self.lib.mkHost`.
- `aspects/hosts/_<host>/**`: host-only modules, auto-imported by import-tree (boot,
  disko, hardware-configuration, per-service modules).
- `aspects/users/user.nix`: registers `flake.homeConfigurations."user@host"` via
  `mkHomeConfiguration`.
- `data/services.nix`: shared host/service data (also imported by terranix);
  `aspects/constants.nix` exposes `flake.hosts`, `flake.services`, `flake.lib`.
- `packages/` custom pkgs + overlays, `terranix/` infra, `shells/` devShell (nixfmt, nil, agenix).

## Adding a host
1. Add a module `flake.modules.nixos.<host>` with base config, or reuse existing modules.
2. Create `aspects/hosts/<host>.nix` calling `mkHost { hostname = "<host>"; ... }`,
   listing aspects in `extraModules = with inputs.self.modules.nixos; [ ... ];`.
3. Create `aspects/hosts/_<host>/` with `hardware-configuration.nix`, `disko.nix`,
   `boot.nix`, and service modules. Files are picked up automatically.
4. If the host runs services, add it to `data/services.nix` (`hosts` + `services`).
5. If a user should get home-manager there, add `flake.homeConfigurations."user@<host>"`
   in `aspects/users/user.nix`.
6. Verify: `nixos build --config apply.use_nom=false`, then
   `nixos apply --config apply.use_nom=false`.

## Conventions
- Reuse, don't duplicate: pull IPs/domains from `data/services.nix` / `inputs.self.services`; never hardcode.
- Format with `nixfmt` (devShell). Check with `nix flake check`.
- Keep module option naming consistent with upstream nixpkgs/home-manager.

## Secrets (agenix)
- Encrypted `*.age` files live in `secrets/`; public keys and per-secret recipients
  are declared in `secrets/secrets.nix`.
- Reference with `age.secrets.<name>.path`; host identity keys are persisted under
  `/persistent/etc/ssh` (see `aspects/ephemeral.nix`).
- Never commit plaintext secrets. Add a new secret by adding an entry to
  `secrets/secrets.nix` and rekeying with `agenix`.

## Terranix / DNS
- Terraform configs in `terranix/` (Cloudflare DNS, OCI VPS, Tailscale) are built
  via the terranix flake module; they read `data/services.nix`.
- Public services get DNS pointed at trantor; private services at their Tailscale IP.
- Cloudflare state lives in R2 (S3 backend); credentials come from env vars
  (`CLOUDFLARE_API_TOKEN`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).
