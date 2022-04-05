locals {
  region = "eu-frankfurt-1"
  user_ocid = "ocid1.user.oc1..aaaabbcc123"
  tenancy_ocid = "ocid1.tenancy.oc1..aaaabbcc123"
  compartment_ocid = "ocid1.tenancy.oc1..aaaabbcc123"
  availability_domain = "VomW:EU-FRANKFURT-1-AD-2"

  image_ocid = "ocid1.image.oc1.eu-frankfurt-1.aaaabbcc123"
  vm_memory = "4"
  vm_ocpus = "1"
  console_ssh_public_key  = "ssh-rsa aaaabbcc123"
  ssh_private_key_path = "~/.oci/oci_api.pem"
  ssh_fingerprint = "57:67:46:00:3:27:81:00:78:54:a7:52:b0:52:62:a1"
  ssh_authorized_keys = "ssh-ed25519 aaaabbcc123"

  # encoded base64 script - use converters/base64 from ports
  #  #!/bin/sh -e -u -o pipefail
  #  touch /var/run/cloud_script
  #  curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode >/var/run/oke-init.sh
  user_base64_encoded_script = "IyEvYmluL3NoIC1lIC11IC1vIHBpcGVmYWlsCnRvdWNoIC92YXIvcnVuL2Nsb3VkX3NjcmlwdApjdXJsIC0tZmFpbCAtSCAiQXV0aG9yaXphdGlvbjogQmVhcmVyIE9yYWNsZSIgLUwwIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvb3BjL3YyL2luc3RhbmNlL21ldGFkYXRhL29rZV9pbml0X3NjcmlwdCB8IGJhc2U2NCAtLWRlY29kZSA+L3Zhci9ydW4vb2tlLWluaXQuc2gKCg=="
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
  display_name = "beastie-arm64-1337"
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
  display_name = "beastie-vcn-1337"
  dns_label = "vcn04051344"
}

resource "oci_core_subnet" "generated_oci_core_subnet" {
  cidr_block = "10.0.0.0/24"
  compartment_id = local.compartment_ocid
  display_name = "beastie-subnet-1337"
  dns_label = "subnet04051344"
  route_table_id = "${oci_core_vcn.generated_oci_core_vcn.default_route_table_id}"
  vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_internet_gateway" "generated_oci_core_internet_gateway" {
  compartment_id = local.compartment_ocid
  display_name = "Internet Gateway beastie-vcn-1337"
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

