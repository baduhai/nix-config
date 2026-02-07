# OCI Terminus configuration placeholder
{ inputs, ... }:

{
  imports = [ inputs.terranix.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      terranix.terranixConfigurations.oci-terminus = {
        terraformWrapper.package = pkgs.opentofu;
        modules = [
          ({ config, ... }: {
            # Terraform config goes here
          })
        ];
      };
    };
}
