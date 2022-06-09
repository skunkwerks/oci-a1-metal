locals {
  mp_subscription_enabled  = var.mp_subscription_enabled ? 1 : 0
  listing_id               = var.mp_listing_id
  listing_resource_id      = var.mp_listing_resource_id
  listing_resource_version = var.mp_listing_resource_version
}
