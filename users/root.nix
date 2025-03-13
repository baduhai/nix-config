{ ... }:

{
  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "22.05";
  };

  imports = [
    ./modules
    ./modules/root
  ];
}
