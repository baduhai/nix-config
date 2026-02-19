{ inputs, ... }:

let
  mkHost = inputs.self.lib.mkHost;
in

{
  flake.nixosConfigurations.trantor = mkHost {
    hostname = "trantor";
    system = "aarch64-linux";
    nixpkgs = inputs.nixpkgs-stable;
    ephemeralRootDev = "/dev/disk/by-id/scsi-360b207ed25d84372a95d1ecf842f8e20-part2";
    extraModules = with inputs.self.modules.nixos; [
      # base aspects
      server
    ];
  };
}
