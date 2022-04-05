locals {
  region = "eu-frankfurt-1"
  user_ocid = "ocid1.user.oc1..aaaaaaaaqnqyyzizfu7qwzgbz3g3bgob73amxgwi4siqx76n3q6xwmnvma6a"
  tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaadlplzdfpt2fa4deyzjw7ioh22lzdqr6gxc2iggh6y5pkdptoxrxq"
  compartment_ocid = "ocid1.tenancy.oc1..aaaaaaaadlplzdfpt2fa4deyzjw7ioh22lzdqr6gxc2iggh6y5pkdptoxrxq"
  availability_domain = "VomW:EU-FRANKFURT-1-AD-2"

  image_ocid = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaiza2re7yog3ozrhoaueve6ayootly227z2ldqnjckfczqqcl5zqa"
  vm_memory = "4"
  vm_ocpus = "1"
  console_ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8OZGfPONqBUYPOVaxmthl6YEfUfUrTppvBLd1m0AotOXUfNIp43foqMwoQ6SJ1fSAsaqXjPydpV1djvxlgh55B8xZoPvT188EefbDYLSHl1FTH/uufiIkRReT5xx4kqg8zhrOR8+kk2ICtwIhZn4SHpJaImutzOfMexFj/H6BPBjiVsWcwj7rlDDEn9Bx1lJ30d/1B7Qlaw5bySTs973BxKAMeny1tOBFOwnOqo93WpZ1dt8GJB+zq763Q2jPqZv3yQUxxPFGUSTzvmrx/WMkaqKW7IKeXZV9oxc8UYCBzU2li+uPMJCbAUpXk50pxNa2Kb2bQBwgEF3LawmfXFkN ~/.oci/oci_api.pem"
  ssh_private_key_path = "~/.oci/oci_api.pem"
  ssh_fingerprint = "57:70:a4:aa:3e:72:d1:ff:39:45:fa:8f:90:98:39:a1"
  ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuuKqa0KEiCFC3Pr5LmWae/ZZfxOQcH9b9jFHLEMC3t ansible@cabal5.net 20201223\nssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZ0cNlRkFRRleUZhFjIZYJ2p7h7wNWvODGBLEzfSfvr dch@skunkwerks.at 20201124\necdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBItIwUr8zhXOBtFH1B0YmNz2WJcY6w1ysRiTAIkI2CBenMb0f7H2pH1rFAa6ZF6dYS3SuLMng+igZUfkqhV/0Km+zus3lAjc37FFiawtATt+/nRj3hj/AaVz/cK7NnWdlg== dch@yk10616337_eccp384_20191024"

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

