{ config, ... }:

{
  terraform.required_providers.oci = {
    source = "oracle/oci";
    version = "~> 5.0";
  };

  provider.oci.region = "sa-saopaulo-1";

  terraform.backend.s3 = {
    bucket = "terraform-state";
    key = "oci/homelab.tfstate";
    region = "auto";
    endpoint = "https://<ACCOUNT_ID>.r2.cloudflarestorage.com";
    skip_credentials_validation = true;
    skip_metadata_api_check = true;
    skip_region_validation = true;
    skip_requesting_account_id = true;
    use_path_style = true;
  };

  variable = {
    compartment_name = {
      default = "homelab";
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
    oci_identity_tenancy.tenancy = { };

    oci_identity_availability_domains.ads = {
      compartment_id = config.data.oci_identity_tenancy.tenancy.id;
    };

    oci_core_images.ubuntu_arm = {
      compartment_id = config.data.oci_identity_tenancy.tenancy.id;
      operating_system = "Canonical Ubuntu";
      operating_system_version = "24.04";
      shape = "VM.Standard.A1.Flex";
      sort_by = "TIMECREATED";
      sort_order = "DESC";
    };
  };

  resource = {
    oci_identity_compartment.homelab = {
      compartment_id = config.data.oci_identity_tenancy.tenancy.id;
      description = "Homelab infrastructure compartment";
      name = config.variable.compartment_name.default;
    };

    oci_core_vcn.vcn = {
      compartment_id = config.resource.oci_identity_compartment.homelab.id;
      cidr_blocks = [ config.variable.vcn_cidr.default ];
      display_name = "homelab-vcn";
      dns_label = "homelab";
    };

    oci_core_internet_gateway.ig = {
      compartment_id = config.resource.oci_identity_compartment.homelab.id;
      vcn_id = config.resource.oci_core_vcn.vcn.id;
      display_name = "homelab-ig";
      enabled = true;
    };

    oci_core_route_table.rt = {
      compartment_id = config.resource.oci_identity_compartment.homelab.id;
      vcn_id = config.resource.oci_core_vcn.vcn.id;
      display_name = "homelab-rt";

      route_rules = [
        {
          network_entity_id = config.resource.oci_core_internet_gateway.ig.id;
          destination = "0.0.0.0/0";
          destination_type = "CIDR_BLOCK";
        }
      ];
    };

    oci_core_security_list.sl = {
      compartment_id = config.resource.oci_identity_compartment.homelab.id;
      vcn_id = config.resource.oci_core_vcn.vcn.id;
      display_name = "homelab-sl";

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
      ];
    };

    oci_core_subnet.subnet = {
      compartment_id = config.resource.oci_identity_compartment.homelab.id;
      vcn_id = config.resource.oci_core_vcn.vcn.id;
      cidr_block = config.variable.vcn_cidr.default;
      display_name = "homelab-subnet";
      dns_label = "subnet";
      route_table_id = config.resource.oci_core_route_table.rt.id;
      security_list_ids = [ config.resource.oci_core_security_list.sl.id ];
      prohibit_public_ip_on_vnic = false;
    };

    oci_core_instance.trantor = {
      availability_domain = config.data.oci_identity_availability_domains.ads.availability_domains .0.name;
      compartment_id = config.resource.oci_identity_compartment.homelab.id;
      display_name = config.variable.instance_name.default;
      shape = "VM.Standard.A1.Flex";

      shape_config = {
        ocpus = 2;
        memory_in_gbs = 12;
      };

      source_details = {
        source_type = "image";
        source_id = config.data.oci_core_images.ubuntu_arm.images .0.id;
        boot_volume_size_in_gbs = 50;
      };

      create_vnic_details = {
        subnet_id = config.resource.oci_core_subnet.subnet.id;
        display_name = "trantor-vnic";
        assign_public_ip = true;
        hostname_label = config.variable.instance_name.default;
      };

      metadata = {
        ssh_authorized_keys = builtins.concatStringsSep "\n" config.variable.ssh_public_keys.default;
      };

      preserve_boot_volume = false;
    };
  };

  output = {
    compartment_id = {
      value = config.resource.oci_identity_compartment.homelab.id;
    };

    instance_public_ip = {
      value = config.resource.oci_core_instance.trantor.public_ip;
    };
  };
}
