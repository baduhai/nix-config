{ inputs, config, pkgs, lib, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bkp";
    users.user = import ../../../users/desktops/user.nix;
  };
}
