{ ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
  };

  imports = [
    ./modules
    ./user
  ];
}
