provider "oci" {}

resource "oci_core_instance" "generated_oci_core_instance" {
	agent_config {
		is_management_disabled = "false"
		is_monitoring_disabled = "false"
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Monitoring"
		}
	}
	availability_config {
		recovery_action = "RESTORE_INSTANCE"
	}
	availability_domain = "Ynwz:eu-amsterdam-1-AD-1"
	compartment_id = "ocid1.tenancy.oc1..aaaaaaaaobmlhruktcqx2vi7r5mdu7eqkzucnjhziwfeb6s6thzgay4ujuhq"
	create_vnic_details {
		assign_private_dns_record = "true"
		assign_public_ip = "true"
		subnet_id = "ocid1.subnet.oc1.eu-amsterdam-1.aaaaaaaa7lfgj4fcyfxlqc7cr4nhottzufvo5zzj2vc4syayk23i4rchenfq"
	}
	display_name = "wat"
	instance_options {
		are_legacy_imds_endpoints_disabled = "false"
	}
	metadata = {
		"ssh_authorized_keys" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZ0cNlRkFRRleUZhFjIZYJ2p7h7wNWvODGBLEzfSfvr dch@skunkwerks.at 20201124"
	}
	shape = "VM.Standard.A1.Flex"
	shape_config {
		memory_in_gbs = "24"
		ocpus = "4"
	}
	source_details {
		source_id = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaabmpqimzufiv6an4qq6qan5k6xwwiewgmtlnzdg5uj264l4hmpu6a"
		source_type = "image"
	}
}
