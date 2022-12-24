{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "micro";
    };
    activation.installMicroPlugins = ''
      ${pkgs.micro}/bin/micro -plugin install filemanager
    '';
  };
}
