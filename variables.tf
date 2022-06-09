variable "region" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "tenancy_ocid" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "availability_domain" {
  type = string
}

variable "image_ocid" {
  type = string
}

variable "vm_memory" {
  type = string
}

variable "vm_ocpus" {
  type = string
}

variable "console_ssh_public_key" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}

variable "ssh_fingerprint" {
  type = string
}

variable "ssh_authorized_keys" {
  type = string
}

variable "boot_script" {
  type = string
}

variable "mp_subscription_enabled" {
  description = "Subscribe to Marketplace listing?"
  type        = bool
  default     = false
}

variable "mp_listing_id" {
  default     = "ocid1.appcataloglisting.oc1..aaaaaaaa52miob5xfolxu32kuxb2jgmdvtdovkisqvr22uozlr2b5cjwjm7a"
  description = "Marketplace Listing OCID"
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaayjatgvecms7kciqjx5exbj4dpcs3ympvpggpodwlfuezn7dejdja"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  default     = "13.1"
  description = "Marketplace Listing Package/Resource Version"
}
