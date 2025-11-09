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
        cloudflare-baduhaidev = {
          modules = [ ./terranix/cloudflare/baduhai.dev.nix ];
          terraformWrapper.package = pkgs.opentofu;
        };
        tailscale-tailnet = {
          modules = [ ./terranix/tailscale/tailnet.nix ];
          terraformWrapper.package = pkgs.opentofu;
        };
      };
    };
}
