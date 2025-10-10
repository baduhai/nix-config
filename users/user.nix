{ inputs, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
  };

  imports = [
    ./modules
    ./modules/user
    inputs.dms.homeModules.dankMaterialShell.default
  ];
}
