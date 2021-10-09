provider "oci" {}

resource "oci_core_instance" "bilbo" {
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
	display_name = "bilbo.cabal5.net"
	instance_options {
		are_legacy_imds_endpoints_disabled = "false"
	}
	metadata = {
		"ssh_authorized_keys" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuuKqa0KEiCFC3Pr5LmWae/ZZfxOQcH9b9jFHLEMC3t ansible@cabal5.net 20201223\nssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZ0cNlRkFRRleUZhFjIZYJ2p7h7wNWvODGBLEzfSfvr dch@skunkwerks.at 20201124\necdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBItIwUr8zhXOBtFH1B0YmNz2WJcY6w1ysRiTAIkI2CBenMb0f7H2pH1rFAa6ZF6dYS3SuLMng+igZUfkqhV/0Km+zus3lAjc37FFiawtATt+/nRj3hj/AaVz/cK7NnWdlg== dch@yk10616337_eccp384_20191024"
	}
	shape = "VM.Standard.A1.Flex"
	shape_config {
		memory_in_gbs = "24"
		ocpus = "4"
	}
	source_details {
		source_type = "image"
	    source_id = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaaevm6ugkqooromkcisry4fhr6frfat6kjmkpwrw3q4uzzzkue6fzq"
		/* ipxe efifat */
		/* source_id = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaaprit3bcx5i6oxmy22intyavttmqcnrttc4rqkiqd4is2q24ym34a" */
	}

    /* ipxe_script = <<-IPXE */
    /*     #!ipxe */
    /*     :restart */
    /*     # gotta get me some DHCP */
    /*     dhcp */
    /*     echo DEVICE SETTINGS.................... */
    /*     echo mac..........$${mac} */
    /*     echo busloc.......$${busloc} */
    /*     echo bustype......$${bustype} */
    /*     echo chip.........$${chiptype} */
    /*     echo HOST SETTINGS...................... */
    /*     echo hostname.....$${hostname} */
    /*     echo uuid.........$${uuid} */
    /*     echo user-class...$${user-class} */
    /*     echo manufacturer.$${manufacturer} */
    /*     echo product......$${product} */
    /*     echo serial.......$${serial} */
    /*     echo NETWORK SETTINGS................... */
    /*     echo ip...........$${ip} */
    /*     echo netmask......$${netmask} */
    /*     echo gateway......$${gateway} */
    /*     echo dns..........$${dns} */
    /*     echo domain.......$${domain} */
    /*     echo BOOT SETTINGS...................... */
    /*     echo filename.....$${netX/filename} */
    /*     echo next-server..$${netX/next-server} */
    /*     echo default-url..$${netX/default-url} */
    /*     echo MISC SETTINGS...................... */
    /*     echo buildarch....$${buildarch} */
    /*     echo platform.....$${platform} */

    /*     # log info via GET that returns empty 200 OK */
    /*     imgfetch http://freeside.skunkwerks.at/pub/ipxe/log?uuid=$${uuid}&mac=$${mac:hexhyp}&domain=$${domain}&hostname=$${hostname}&serial=$${serial}&platform=$${platform}&buildarch=$${buildarch}           || */
    /*     imgfree */
    /*     # if there is an ipxe script for this system use that */
    /*     # else fall through increasingly generic scripts */
    /*     chain http://freeside.skunkwerks.at/pub/ipxe/$${uuid}             || */
    /*     chain http://freeside.skunkwerks.at/pub/ipxe/$${serial}           || */
    /*     chain http://freeside.skunkwerks.at/pub/ipxe/$${mac}              || */
    /*     chain http://freeside.skunkwerks.at/pub/ipxe/$${hostname}         || */
    /*     chain http://freeside.skunkwerks.at/pub/ipxe/$${netX/default-url} || */

    /*     :prompt */
    /*     imgfetch http://freeside.skunkwerks.at/pub/$${platform}-$${buildarch}/boot/loader.efi || */
    /*     prompt --key 0x1b --timeout 5000 Press ESC for iPXE shell... && shell || */
    /*     boot loader.efi || */
    /*     :restart */
    /*     chain http://freeside.skunkwerks.at/pub/ipxe/ipxe.sh */
/* IPXE */
}


resource "oci_core_instance_console_connection" "bilbo_console" {
  instance_id = oci_core_instance.bilbo.id
  public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8OZGfPONqBUYPOVaxmthl6YEfUfUrTppvBLd1m0AotOXUfNIp43foqMwoQ6SJ1fSAsaqXjPydpV1djvxlgh55B8xZoPvT188EefbDYLSHl1FTH/uufiIkRReT5xx4kqg8zhrOR8+kk2ICtwIhZn4SHpJaImutzOfMexFj/H6BPBjiVsWcwj7rlDDEn9Bx1lJ30d/1B7Qlaw5bySTs973BxKAMeny1tOBFOwnOqo93WpZ1dt8GJB+zq763Q2jPqZv3yQUxxPFGUSTzvmrx/WMkaqKW7IKeXZV9oxc8UYCBzU2li+uPMJCbAUpXk50pxNa2Kb2bQBwgEF3LawmfXFkN oracle_rsa"
}

