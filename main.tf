# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformconfig.htm#terraformconfig_topic_Configuration_File_Requirements_Provider

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
  availability_domain = var.availability_domain
  compartment_id = var.compartment_ocid
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
    "ssh_authorized_keys" = var.ssh_authorized_keys
    "user_data" = base64encode(var.boot_script)
  }
  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = var.vm_memory
    ocpus = var.vm_ocpus
  }
  source_details {
    source_id = var.image_ocid
    source_type = "image"
  }
}

resource "oci_core_vcn" "generated_oci_core_vcn" {
  cidr_block = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name = "beastie"
  dns_label = "beastie"
}

resource "oci_core_subnet" "generated_oci_core_subnet" {
  cidr_block = "10.0.0.0/24"
  compartment_id = var.compartment_ocid
  display_name = "beastie"
  dns_label = "beastie"
  route_table_id = "${oci_core_vcn.generated_oci_core_vcn.default_route_table_id}"
  vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_internet_gateway" "generated_oci_core_internet_gateway" {
  compartment_id = var.compartment_ocid
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
  public_key = var.console_ssh_public_key
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

