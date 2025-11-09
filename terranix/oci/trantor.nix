# Required environment variables:
#   instead of OCI variables, ~/.oci/config may also be used
#   OCI_TENANCY_OCID - Oracle tenancy OCID (or use TF_VAR_* to override variables)
#   OCI_USER_OCID - Oracle user OCID
#   OCI_FINGERPRINT - API key fingerprint
#   OCI_PRIVATE_KEY_PATH - Path to OCI API private key
#   AWS variables are required
#   AWS_ACCESS_KEY_ID - Cloudflare R2 access key for state storage
#   AWS_SECRET_ACCESS_KEY - Cloudflare R2 secret key for state storage

{ config, ... }:

{
  terraform.required_providers.oci = {
    source = "oracle/oci";
    version = "~> 7.0";
  };

  provider.oci.region = "sa-saopaulo-1";

  terraform.backend.s3 = {
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

  variable = {
    tenancy_ocid = {
      default = "ocid1.tenancy.oc1..aaaaaaaap3vfdz4piygqza6e6zqunbcuso43ddqfo3ydmpmnomidyghh7rvq";
      type = "string";
    };

    compartment_name = {
      default = "trantor";
      type = "string";
    };

    vcn_cidr = {
      default = "10.0.0.0/24";
      type = "string";
    };

    instance_name = {
      default = "trantor";
      type = "string";
    };

    ssh_public_keys = {
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Y0PVpGfJHonqDS7qoCFhqzUvqGq9I9sax+F9e/5cs user@io"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL user@rotterdam"
      ];
      type = "list(string)";
    };
  };

  data = {
    oci_identity_availability_domains.ads = {
      compartment_id = config.variable.tenancy_ocid.default;
    };

    oci_core_images.ubuntu_arm = {
      compartment_id = config.variable.tenancy_ocid.default;
      operating_system = "Canonical Ubuntu";
      operating_system_version = "24.04";
      shape = "VM.Standard.A1.Flex";
      sort_by = "TIMECREATED";
      sort_order = "DESC";
    };
  };

  resource = {
    oci_identity_compartment.trantor = {
      compartment_id = config.variable.tenancy_ocid.default;
      description = "trantor infrastructure compartment";
      name = config.variable.compartment_name.default;
    };

    oci_core_vcn.vcn = {
      compartment_id = config.resource.oci_identity_compartment.trantor "id";
      cidr_blocks = [ config.variable.vcn_cidr.default ];
      display_name = "trantor-vcn";
      dns_label = "trantor";
    };

    oci_core_internet_gateway.ig = {
      compartment_id = config.resource.oci_identity_compartment.trantor "id";
      vcn_id = config.resource.oci_core_vcn.vcn "id";
      display_name = "trantor-ig";
      enabled = true;
    };

    oci_core_route_table.rt = {
      compartment_id = config.resource.oci_identity_compartment.trantor "id";
      vcn_id = config.resource.oci_core_vcn.vcn "id";
      display_name = "trantor-rt";

      route_rules = [
        {
          network_entity_id = config.resource.oci_core_internet_gateway.ig "id";
          destination = "0.0.0.0/0";
          destination_type = "CIDR_BLOCK";
        }
      ];
    };

    oci_core_security_list.sl = {
      compartment_id = config.resource.oci_identity_compartment.trantor "id";
      vcn_id = config.resource.oci_core_vcn.vcn "id";
      display_name = "trantor-sl";

      egress_security_rules = [
        {
          destination = "0.0.0.0/0";
          protocol = "all";
          stateless = false;
        }
      ];

      ingress_security_rules = [
        {
          protocol = "6"; # TCP
          source = "0.0.0.0/0";
          stateless = false;
          tcp_options = {
            min = 22;
            max = 22;
          };
        }
        {
          protocol = "6"; # TCP
          source = "0.0.0.0/0";
          stateless = false;
          tcp_options = {
            min = 80;
            max = 80;
          };
        }
        {
          protocol = "6"; # TCP
          source = "0.0.0.0/0";
          stateless = false;
          tcp_options = {
            min = 443;
            max = 443;
          };
        }
        {
          protocol = "6"; # TCP
          source = "0.0.0.0/0";
          stateless = false;
          tcp_options = {
            min = 25565;
            max = 25565;
          };
        }
        {
          protocol = "6"; # TCP
          source = "0.0.0.0/0";
          stateless = false;
          tcp_options = {
            min = 19132;
            max = 19133;
          };
        }
        {
          protocol = "17"; # UDP
          source = "0.0.0.0/0";
          stateless = false;
          udp_options = {
            min = 19132;
            max = 19133;
          };
        }
      ];
    };

    oci_core_subnet.subnet = {
      compartment_id = config.resource.oci_identity_compartment.trantor "id";
      vcn_id = config.resource.oci_core_vcn.vcn "id";
      cidr_block = config.variable.vcn_cidr.default;
      display_name = "trantor-subnet";
      dns_label = "subnet";
      route_table_id = config.resource.oci_core_route_table.rt "id";
      security_list_ids = [ (config.resource.oci_core_security_list.sl "id") ];
      prohibit_public_ip_on_vnic = false;
    };

    oci_core_instance.trantor = {
      availability_domain = config.data.oci_identity_availability_domains.ads "availability_domains[0].name";
      compartment_id = config.resource.oci_identity_compartment.trantor "id";
      display_name = config.variable.instance_name.default;
      shape = "VM.Standard.A1.Flex";

      shape_config = {
        ocpus = 2;
        memory_in_gbs = 12;
      };

      source_details = {
        source_type = "image";
        source_id = config.data.oci_core_images.ubuntu_arm "images[0].id";
        boot_volume_size_in_gbs = 100;
      };

      create_vnic_details = {
        subnet_id = config.resource.oci_core_subnet.subnet "id";
        display_name = "trantor-vnic";
        assign_public_ip = true;
        hostname_label = config.variable.instance_name.default;
      };

      metadata = {
        ssh_authorized_keys = builtins.concatStringsSep "\n" config.variable.ssh_public_keys.default;
      };

      preserve_boot_volume = false;
    };

    oci_budget_budget.trantor_budget = {
      compartment_id = config.variable.tenancy_ocid.default;
      targets = [ (config.resource.oci_identity_compartment.trantor "id") ];
      amount = 1;
      reset_period = "MONTHLY";
      display_name = "trantor-budget";
      description = "Monthly budget for trantor compartment";
      target_type = "COMPARTMENT";
    };

    oci_budget_alert_rule.daily_spend_alert = {
      budget_id = config.resource.oci_budget_budget.trantor_budget "id";
      type = "ACTUAL";
      threshold = 5;
      threshold_type = "PERCENTAGE";
      display_name = "daily-spend-alert";
      recipients = "baduhai@proton.me";
      description = "Alert when daily spending exceeds $0.05";
      message = "Daily spending has exceeded $0.05 in the trantor compartment";
    };
  };

  output = {
    compartment_id = {
      value = config.resource.oci_identity_compartment.trantor "id";
    };

    instance_public_ip = {
      value = config.resource.oci_core_instance.trantor "public_ip";
    };
  };
}
