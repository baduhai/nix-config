{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  home-manager.users.user = import ../../../users/servers/user.nix";
}
