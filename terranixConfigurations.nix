{ inputs, ... }:

{
  imports = [
    inputs.terranix.flakeModule
  ];

  perSystem =
    { pkgs, ... }:

    {
      terranix.terranixConfigurations = {
        oci-trantor = {
          modules = [ ./terranix/oci/trantor.nix ];
          terraformWrapper.package = pkgs.opentofu;
        };
      };
    };
}
