locals {
  region = "eu-amsterdam-1"
  user_ocid = "ocid1.user.oc1..aaaa"
  tenancy_ocid = "ocid1.tenancy.oc1..aaaa"
  compartment_ocid = "ocid1.tenancy.oc1..aaaa"
  availability_domain = "Ynwz:eu-amsterdam-1-AD-1"
  image_ocid = "ocid1.image.oc1.eu-amsterdam-1.aaaa"

  vm_memory = "24"
  vm_ocpus = "4"
  console_ssh_public_key  = "ssh-rsa aaaa"
  ssh_private_key_path = "~/.oci/oci_api.pem"
  ssh_fingerprint = "57:70:a4:aa:3e:72:d1:ff:39:45:fa:8f:90:98:39:a1"
  ssh_authorized_keys = "ssh-ed25519 aaaa"

  user_base64_encoded_script = base64encode(
    <<-CLOUDSCRIPT
    #!/bin/sh -eu
    set -o pipefail
    touch /var/run/cloud_script_was_here
    # https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/gettingmetadata.htm
    curl --fail -H "Authorization: Bearer Oracle" -s \
      http://169.254.169.254/opc/v2/instance \
        | jq . >/var/run/oci_metadata.json
    CLOUDSCRIPT
    )
}

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformconfig.htm#terraformconfig_topic_Configuration_File_Requirements_Provider

provider "oci" {
  tenancy_ocid = local.tenancy_ocid
  user_ocid = local.user_ocid
  private_key_path = local.ssh_private_key_path
  fingerprint = local.ssh_fingerprint
  region = local.region
}

resource "oci_core_instance" "beastie" {
  agent_config {
    is_management_disabled = "true"
    is_monitoring_disabled = "true"
    plugins_config {
      desired_state = "DISABLED"
      name = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name = "Oracle Autonomous Linux"
    }
    plugins_config {
      desired_state = "DISABLED"
      name = "OS Management Service Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "DISABLED"
      name = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name = "Block Volume Management"
    }
    plugins_config {
      desired_state = "DISABLED"
      name = "Bastion"
    }
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = local.availability_domain
  compartment_id = local.compartment_ocid
  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip = "true"
    subnet_id = "${oci_core_subnet.generated_oci_core_subnet.id}"
  }
  display_name = "beastie"
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  metadata = {
    "ssh_authorized_keys" = local.ssh_authorized_keys
    "user_data" = local.user_base64_encoded_script
  }
  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = local.vm_memory
    ocpus = local.vm_ocpus
  }
  source_details {
    source_id = local.image_ocid
    source_type = "image"
  }
}

resource "oci_core_vcn" "generated_oci_core_vcn" {
  cidr_block = "10.0.0.0/16"
  compartment_id = local.compartment_ocid
  display_name = "beastie"
  dns_label = "beastie"
}

resource "oci_core_subnet" "generated_oci_core_subnet" {
  cidr_block = "10.0.0.0/24"
  compartment_id = local.compartment_ocid
  display_name = "beastie"
  dns_label = "beastie"
  route_table_id = "${oci_core_vcn.generated_oci_core_vcn.default_route_table_id}"
  vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_internet_gateway" "generated_oci_core_internet_gateway" {
  compartment_id = local.compartment_ocid
  display_name = "beastie"
  enabled = "true"
  vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_default_route_table" "generated_oci_core_default_route_table" {
  route_rules {
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.generated_oci_core_internet_gateway.id}"
  }
  manage_default_resource_id = "${oci_core_vcn.generated_oci_core_vcn.default_route_table_id}"
}

resource "oci_core_instance_console_connection" "beastie_console" {
  instance_id = oci_core_instance.beastie.id
  public_key = local.console_ssh_public_key
}


output "oid" {
  value = oci_core_instance.beastie.id
}

output "ssh" {
  value = oci_core_instance_console_connection.beastie_console.connection_string
}

output "public_ip" {
  value = oci_core_instance.beastie.public_ip
}
output "private_ip" {
  value = oci_core_instance.beastie.private_ip
}

