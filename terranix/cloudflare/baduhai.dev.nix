# Required environment variables:
#   CLOUDFLARE_API_TOKEN - API token with "Edit zone DNS" permissions
#   AWS_ACCESS_KEY_ID - Cloudflare R2 access key for state storage
#   AWS_SECRET_ACCESS_KEY - Cloudflare R2 secret key for state storage

{ config, lib, ... }:

let
  inherit (import ../../shared/services.nix) services;

  # Helper to extract subdomain from full domain (e.g., "git.baduhai.dev" -> "git")
  getSubdomain = domain: lib.head (lib.splitString "." domain);

  # Generate DNS records for services
  # Public services point to trantor's public IP
  # Private services point to their tailscale IP
  mkServiceRecords = lib.listToAttrs (
    lib.imap0 (i: svc:
      let
        subdomain = getSubdomain svc.domain;
        targetIP = if svc.public or false
          then config.data.terraform_remote_state.trantor "outputs.instance_public_ip"
          else svc.tailscaleIP;
      in {
        name = "service_${toString i}";
        value = {
          zone_id = config.variable.zone_id.default;
          name = subdomain;
          type = "A";
          content = targetIP;
          proxied = false;
          ttl = 3600;
        };
      }
    ) services
  );
in

{
  terraform.required_providers.cloudflare = {
    source = "cloudflare/cloudflare";
    version = "~> 5.0";
  };

  terraform.backend.s3 = {
    bucket = "terraform-state";
    key = "cloudflare/baduhai.dev.tfstate";
    region = "auto";
    endpoint = "https://fcdf920bde00c3d013ee541f984da70e.r2.cloudflarestorage.com";
    skip_credentials_validation = true;
    skip_metadata_api_check = true;
    skip_region_validation = true;
    skip_requesting_account_id = true;
    use_path_style = true;
  };

  variable = {
    zone_id = {
      default = "c63a8332fdddc4a8e5612ddc54557044";
      type = "string";
    };
  };

  data = {
    terraform_remote_state.trantor = {
      backend = "s3";
      config = {
        bucket = "terraform-state";
        key = "oci/trantor.tfstate";
        region = "auto";
        endpoint = "https://fcdf920bde00c3d013ee541f984da70e.r2.cloudflarestorage.com";
        skip_credentials_validation = true;
        skip_metadata_api_check = true;
        skip_region_validation = true;
        skip_requesting_account_id = true;
        use_path_style = true;
      };
    };
  };

  resource = {
    cloudflare_dns_record = mkServiceRecords // {
      root = {
        zone_id = config.variable.zone_id.default;
        name = "@";
        type = "A";
        content = config.data.terraform_remote_state.trantor "outputs.instance_public_ip";
        proxied = false;
        ttl = 3600;
      };

      www = {
        zone_id = config.variable.zone_id.default;
        name = "www";
        type = "A";
        content = config.data.terraform_remote_state.trantor "outputs.instance_public_ip";
        proxied = false;
        ttl = 3600;
      };
    };
  };
}
