{ ... }:

{
  perSystem =
    { pkgs, lib, ... }:
    let
      fastfetch-logo = pkgs.fetchurl {
        url = "https://discourse.nixos.org/uploads/default/original/3X/3/6/36954e6d6aa32c8b00f50ca43f142d898c1ff535.png";
        hash = "sha256-aLHz8jSAFocrn+Pb4vRq0wtkYFJpBpZRevd+VoZC/PQ=";
      };

      fastfetch-config = pkgs.writeText "fastfetch-config.json" (
        builtins.toJSON {
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
          modules = [
            "title"
            "separator"
            {
              type = "os";
              keyWidth = 9;
            }
            {
              type = "kernel";
              keyWidth = 9;
            }
            {
              type = "uptime";
              keyWidth = 9;
            }
            {
              type = "shell";
              keyWidth = 9;
            }
            "break"
            {
              type = "cpu";
              keyWidth = 11;
            }
            {
              type = "memory";
              keyWidth = 11;
            }
            {
              type = "swap";
              keyWidth = 11;
            }
            {
              type = "disk";
              folders = "/";
              keyWidth = 11;
            }
            {
              type = "command";
              key = "Systemd";
              keyWidth = 11;
              text = "echo \"$(systemctl list-units --state=failed --no-legend | wc -l) failed units, $(systemctl list-jobs --no-legend | wc -l) queued jobs\"";
            }
            "break"
            {
              type = "command";
              key = "Public IP";
              keyWidth = 15;
              text = "curl -s -4 ifconfig.me 2>/dev/null || echo 'N/A'";
            }
            {
              type = "command";
              key = "Tailscale IP";
              keyWidth = 15;
              text = "tailscale ip -4 2>/dev/null || echo 'N/A'";
            }
            {
              type = "command";
              key = "Local IP";
              keyWidth = 15;
              text = "ip -4 addr show scope global | grep inet | head -n1 | awk '{print $2}' | cut -d/ -f1";
            }
          ];
        }
      );
    in
    {
      packages.fastfetch = pkgs.writeShellScriptBin "fastfetch" ''exec ${lib.getExe pkgs.fastfetch} --config ${fastfetch-config} --logo-type kitty --logo ${fastfetch-logo} --logo-padding-right 1 --logo-width 36 "$@" '';
    };
}
