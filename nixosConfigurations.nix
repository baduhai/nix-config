{ inputs, ... }:
let
  utils = import ./utils.nix { inherit inputs; };
  inherit (utils) mkHost;
in
{
  flake.nixosConfigurations = {
    rotterdam = mkHost {
      hostname = "rotterdam";
      tags = [
        "desktop"
        "bluetooth"
        "dev"
        "ephemeral"
        "fwupd"
        "gaming"
        "libvirtd"
        "networkmanager"
        "podman"
      ];
    };

    io = mkHost {
      hostname = "io";
      tags = [
        "desktop"
        "bluetooth"
        "dev"
        "ephemeral"
        "networkmanager"
        "podman"
      ];
    };

    alexandria = mkHost {
      hostname = "alexandria";
      tags = [
        "fwupd"
        "podman"
      ];
    };

    trantor = mkHost {
      hostname = "trantor";
      system = "aarch64-linux";
      tags = [
      ];
    };
  };
}
