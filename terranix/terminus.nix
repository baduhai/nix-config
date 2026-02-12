# OCI Terminus configuration placeholder
{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      terranix.terranixConfigurations.oci-terminus = {
        terraformWrapper.package = pkgs.opentofu;
        modules = [
          (
            { config, ... }:
            {
              # Terraform config goes here
            }
          )
        ];
      };
    };
}
