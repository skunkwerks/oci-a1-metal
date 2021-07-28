provider "oci" {}

resource "oci_core_instance" "generated_oci_core_instance" {
	agent_config {
		is_management_disabled = "true"
		is_monitoring_disabled = "true"
		plugins_config {
			desired_state = "DISABLED"
			name = "Vulnerability Scanning"
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
	availability_domain = "Ynwz:eu-amsterdam-1-AD-1"
	compartment_id = "ocid1.tenancy.oc1..aaaaaaaaobmlhruktcqx2vi7r5mdu7eqkzucnjhziwfeb6s6thzgay4ujuhq"
	create_vnic_details {
		assign_private_dns_record = "true"
		assign_public_ip = "true"
		subnet_id = "ocid1.subnet.oc1.eu-amsterdam-1.aaaaaaaa7lfgj4fcyfxlqc7cr4nhottzufvo5zzj2vc4syayk23i4rchenfq"
	}
	display_name = "beastie"
	instance_options {
		are_legacy_imds_endpoints_disabled = "false"
	}
	metadata = {
		"ssh_authorized_keys" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZ0cNlRkFRRleUZhFjIZYJ2p7h7wNWvODGBLEzfSfvr dch@skunkwerks.at 20201124\necdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBItIwUr8zhXOBtFH1B0YmNz2WJcY6w1ysRiTAIkI2CBenMb0f7H2pH1rFAa6ZF6dYS3SuLMng+igZUfkqhV/0Km+zus3lAjc37FFiawtATt+/nRj3hj/AaVz/cK7NnWdlg== dch@yk10616337_eccp384_20191024"
	}
	shape = "VM.Standard.A1.Flex"
	shape_config {
		memory_in_gbs = "24"
		ocpus = "4"
	}
	source_details {
		source_id = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaaajpkvg6f3hoqfhwldwzzc3pfp6smizimjo5cpk7phufadhryhsaa"
		source_type = "image"
	}
}
