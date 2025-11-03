{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  utils = import ./utils.nix { inherit inputs lib; };
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
        # "server" TODO: uncomment when 25.11 is out.
        "fwupd"
        "podman"
      ];
    };

    trantor = mkHost {
      hostname = "trantor";
      system = "aarch64-linux";
      tags = [
        "server"
        "ephemeral"
      ];
    };
  };
}
