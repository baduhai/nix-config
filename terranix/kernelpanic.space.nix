# Cloudflare kernelpanic.space configuration placeholder
{ inputs, ... }:

{
  imports = [ inputs.terranix.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      terranix.terranixConfigurations.cloudflare-kernelpanicspace = {
        terraformWrapper.package = pkgs.opentofu;
        modules = [
          ({ config, ... }: {
            # Terraform config goes here
          })
        ];
      };
    };
}
