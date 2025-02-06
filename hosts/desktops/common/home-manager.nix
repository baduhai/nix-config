{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bkp";
    users.user = {
      imports = [
        ../../../users/desktops/user.nix
        inputs.mithrill-shell.homeManagerModules.default
      ];
    };
  };
}
