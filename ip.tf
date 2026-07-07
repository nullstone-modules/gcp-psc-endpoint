// Static internal IP for the PSC endpoint's forwarding rule.
resource "google_compute_address" "this" {
  name         = local.resource_name
  region       = local.psc_region
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = google_compute_subnetwork.endpoint.id
  labels       = local.labels
}
