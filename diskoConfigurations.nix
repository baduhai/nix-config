{ inputs, ... }:

{
  imports = [
    inputs.disko.flakeModule
  ];

  flake.diskoConfigurations = {
    io.modules = [ ./disko/io.nix ];
    trantor.modules = [ ./disko/trantor.nix ];
  };
}
