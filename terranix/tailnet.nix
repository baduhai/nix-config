# Required environment variables:
#   TAILSCALE_API_KEY - Tailscale API key with appropriate permissions
#   TAILSCALE_TAILNET - Your tailnet name (e.g., "user@example.com" or "example.org.github")
#   AWS_ACCESS_KEY_ID - Cloudflare R2 access key for state storage
#   AWS_SECRET_ACCESS_KEY - Cloudflare R2 secret key for state storage

{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      terranix.terranixConfigurations.tailscale-tailnet = {
        terraformWrapper.package = pkgs.opentofu;
        modules = [
          (
            { config, ... }:
            {
              terraform.required_providers.tailscale = {
                source = "tailscale/tailscale";
                version = "~> 0.17";
              };

              terraform.backend.s3 = {
                bucket = "terraform-state";
                key = "tailscale/tailnet.tfstate";
                region = "auto";
                endpoint = "https://fcdf920bde00c3d013ee541f984da70e.r2.cloudflarestorage.com";
                skip_credentials_validation = true;
                skip_metadata_api_check = true;
                skip_region_validation = true;
                skip_requesting_account_id = true;
                use_path_style = true;
              };

              variable = {
                trantor_tailscale_ip = {
                  default = "100.108.5.90";
                  type = "string";
                };
              };

              resource = {
                tailscale_dns_nameservers.global = {
                  nameservers = [
                    config.variable.trantor_tailscale_ip.default
                    "1.1.1.1"
                    "1.0.0.1"
                  ];
                };
              };
            }
          )
        ];
      };
    };
}
