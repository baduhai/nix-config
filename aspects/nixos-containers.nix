{ ... }:
{
  flake.modules.nixos.nixos-containers =
    {
      config,
      lib,
      pkgs,
      options,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          boot.enableContainers = true;

          networking.nat = {
            enable = true;
            internalInterfaces = [ "ve-*" ];
          };

          # nixos-container's AUTO_START=1 flag is written but never read by
          # nixpkgs, so honor it here. A service (not a systemd generator) so
          # it runs after local-fs, where impermanence bind-mounts of
          # /etc/nixos-containers are up on ephemeral hosts.
          systemd.services.nixos-containers-autostart = {
            description = "Start NixOS containers flagged AUTO_START=1";
            wantedBy = [ "machines.target" ];
            before = [ "machines.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            path = [ config.systemd.package ];
            script = ''
              set -eu

              conf_dir=/etc/nixos-containers
              [ -d "$conf_dir" ] || exit 0

              for conf in "$conf_dir"/*.conf; do
                [ -e "$conf" ] || continue

                autostart=0
                while IFS= read -r line; do
                  case "$line" in
                    AUTO_START=1) autostart=1 ;;
                  esac
                done < "$conf"
                [ "$autostart" -eq 1 ] || continue

                name="''${conf##*/}"
                name="''${name%.conf}"
                systemctl start "container@$name.service" || true
              done
            '';
          };
        }

        # Persist container confs/roots on hosts that use impermanence.
        # Use optionalAttrs (not mkIf) so the definition isn't emitted at all
        # when the option is absent; mkIf still triggers the unmatched-option
        # check. Guard on the parent option because environment.persistence is
        # an attrsOf submodule (`.main` isn't statically declared).
        (lib.optionalAttrs (options ? environment.persistence) {
          environment.persistence.main.directories = [
            "/etc/nixos-containers"
            "/var/lib/nixos-containers"
          ];
        })
      ];
    };
}
