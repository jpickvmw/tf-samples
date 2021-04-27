provider "nsxt" {
  host                  = "172.16.10.33"
  username              = var.nsx-username
  password              = var.nsx-password 
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}

data "nsxt_policy_tier1_gateway" "t1router" {
  display_name = "T1-ROUTER"
}

data "nsxt_policy_transport_zone" "overlayzone" {
  display_name = "nsx-overlay-transportzone"
}

resource "nsxt_policy_segment" "segment1" {
  display_name        = "segment1"
  description         = "Terraform provisioned Segment"
  connectivity_path   = data.nsxt_policy_tier1_gateway.t1router.path
  transport_zone_path = data.nsxt_policy_transport_zone.overlayzone.path

  subnet {
    cidr        = "12.12.2.1/24"
      }
}
