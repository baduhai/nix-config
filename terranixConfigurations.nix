{ inputs, ... }:

{
  imports = [
    inputs.terranix.flakeModule
  ];

  perSystem = {
    terranix.terranixConfigurations = {
      oci-homelab = {
        modules = [ ./terranix/oci/homelab.nix ];
      };
    };
  };
}
