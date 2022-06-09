terraform {
  required_version = ">= 1.1.0"
}

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
provider "oci" {
  tenancy_ocid      = var.tenancy_ocid
  user_ocid         = var.user_ocid
  fingerprint       = var.ssh_fingerprint
  private_key_path  = var.ssh_private_key_path
  region            = var.region
}

