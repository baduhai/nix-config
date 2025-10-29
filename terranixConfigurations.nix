{ inputs, ... }:

{
  imports = [
    inputs.terranix.flakeModule
  ];

  perSystem = {
    terranix.terranixConfigurations = {
      # Example:
      # myconfig = {
      #   modules = [ ./terraform/myconfig.nix ];
      #   extraArgs = { };  # optional
      # };
    };
  };
}
