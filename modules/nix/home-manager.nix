{
  inputs,
  config,
  ...
}:

let
  home-manager-config =
    { lib, ... }:
    {
      home-manager = {
        verbose = false;
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        backupCommand = "rm";
        overwriteBackup = true;
      };
    };
in

{
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };
}
