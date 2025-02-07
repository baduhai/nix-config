{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bkp";
    users.user = {
      imports = [
        ../../../users/desktops/user.nix
        inputs.tritanium-shell.homeManagerModules.default
      ];
    };
  };
}
