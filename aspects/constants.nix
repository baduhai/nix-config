{
  inputs,
  lib,
  config,
  ...
}:

let
  # Host submodule type
  hostType = lib.types.submodule {
    options = {
      lanIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "LAN IP address for the host";
      };
      tailscaleIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Tailscale IP address for the host";
      };
    };
  };

  # Service submodule type
  serviceType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Service name";
      };
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name for the service";
      };
      host = lib.mkOption {
        type = lib.types.str;
        description = "Host where the service runs";
      };
      public = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the service is publicly accessible";
      };
      lanIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "LAN IP address (inherited from host)";
      };
      tailscaleIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Tailscale IP address (inherited from host)";
      };
    };
  };

  # Import shared data (also used by terranix)
  sharedData = import ../data/services.nix;

  # Enrich services with host IP information
  enrichServices =
    hosts: services:
    map (
      svc:
      let
        hostInfo = hosts.${svc.host} or { };
      in
      svc
      // {
        lanIP = hostInfo.lanIP or null;
        tailscaleIP = hostInfo.tailscaleIP or null;
      }
    ) services;

in
{
  options.flake = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf hostType;
      default = { };
      description = "Host definitions with IP addresses";
    };

    services = lib.mkOption {
      type = lib.types.listOf serviceType;
      default = [ ];
      description = "Service definitions with enriched host information";
    };

    lib = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = { };
      description = "Utility functions for flake configuration";
    };
  };

  config.flake = {
    hosts = sharedData.hosts;

    services = enrichServices config.flake.hosts sharedData.services;

    lib = {
      # Nginx virtual host utilities
      mkNginxVHosts =
        { domains }:
        let
          mkVHostConfig =
            domain: vhostConfig:
            lib.recursiveUpdate {
              useACMEHost = domain;
              forceSSL = true;
              kTLS = true;
            } vhostConfig;
        in
        lib.mapAttrs mkVHostConfig domains;

      # Split DNS utilities for unbound
      # Generates unbound view config from a list of DNS entries
      mkSplitDNS =
        entries:
        let
          tailscaleData = map (e: ''"${e.domain}. IN A ${e.tailscaleIP}"'') entries;
          lanData = map (e: ''"${e.domain}. IN A ${e.lanIP}"'') entries;
        in
        [
          {
            name = "tailscale";
            view-first = true;
            local-zone = ''"baduhai.dev." transparent'';
            local-data = tailscaleData;
          }
          {
            name = "lan";
            view-first = true;
            local-zone = ''"baduhai.dev." transparent'';
            local-data = lanData;
          }
        ];
      # Generates a NixOS container with sane defaults for this repo.
      #
      # Private-network containers get a fixed veth subnet derived from their
      # index (10.233.<index>.0/24) so the host nginx can reach them, and a
      # resolv.conf pointing at the veth gateway where the shared-net unbound
      # container listens. Data lives in the container root
      # (/var/lib/nixos-containers/<name>), which nixos-containers.nix keeps
      # persistent on ephemeral hosts.
      mkContainer =
        {
          index ? null,
          privateNetwork ? true,
          bindMounts ? { },
          specialArgs ? { },
          forwardPorts ? [ ],
          config,
        }:
        {
          autoStart = true;
          inherit
            privateNetwork
            specialArgs
            forwardPorts
            ;
          bindMounts = {
            "/run/agenix" = {
              hostPath = "/run/agenix";
              isReadOnly = true;
            };
          }
          // bindMounts;
          config = {
            imports = [
              {
                system.stateVersion = "22.11";
                # Shared-net containers would otherwise rewrite the host's
                # nftables ruleset; private ones have no ingress but the host.
                networking.firewall.enable = false;
              }
              (lib.optionalAttrs privateNetwork {
                networking = {
                  nameservers = [ "10.233.${toString index}.1" ];
                  resolvconf.enable = false;
                };
                environment.etc."resolv.conf".text = "nameserver 10.233.${toString index}.1\n";
              })
              config
            ];
          };
        }
        // lib.optionalAttrs privateNetwork {
          hostAddress = "10.233.${toString index}.1";
          localAddress = "10.233.${toString index}.2";
        };
      # Generates flake.homeConfigurations
      mkHomeConfiguration =
        {
          user,
          hostname,
          system ? "x86_64-linux",
          stateVersion ? "22.05",
          nixpkgs ? inputs.nixpkgs, # override with e.g. inputs.nixpkgs-stable
          userModules ? [ ],
          overlays ? [ inputs.self.overlays.default ],
          homeManagerModules ? with inputs.self.modules.homeManager; [
            base
            cli
          ],
          userDirectory ? "/home/${user}",
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          extraSpecialArgs = {
            inherit inputs hostname;
          };

          modules = [
            { nixpkgs.overlays = overlays; }
            {
              home = {
                username = user;
                homeDirectory = userDirectory;
                inherit stateVersion;
              };
            }
            ((inputs.import-tree.initFilter (p: lib.hasSuffix ".nix" p))
              "/${inputs.self}/aspects/users/_${user}"
            )
          ]
          ++ homeManagerModules
          ++ userModules;
        };
      # Generates flake.nixosConfigurations
      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
          nixpkgs ? inputs.nixpkgs,
          overlays ? [
            inputs.agenix.overlays.default
            inputs.self.overlays.default
          ],
          ephemeralRootDev ? null, # pass rootDevice string to enable, e.g. ephemeralephemeralRootDev = "/dev/mapper/cryptroot"
          nixosModules ? with inputs.self.modules.nixos; [
            base
            cli
            user
            root
          ],
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            inputs.agenix.nixosModules.default
            { networking.hostName = hostname; }
            { nixpkgs.overlays = overlays; }
            ((inputs.import-tree.initFilter (p: lib.hasSuffix ".nix" p))
              "${inputs.self}/aspects/hosts/_${hostname}"
            )
          ]
          ++ (lib.optional (ephemeralRootDev != null) (
            inputs.self.factory.ephemeral { rootDevice = ephemeralRootDev; }
          ))
          ++ nixosModules
          ++ extraModules;
        };
    };
  };
}
