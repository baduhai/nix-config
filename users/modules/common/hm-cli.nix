{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ hm-cli ];
    sessionVariables = {
      HM_PATH = "/etc/nixos";
    };
  };
}
