// The PSC endpoint: a forwarding rule targeting the service attachment published by the producer.
// The producer publishes with ACCEPT_MANUAL; until this GCP project is in the producer's
// consumer allowlist, psc_connection_status remains PENDING and traffic will not flow.
resource "google_compute_forwarding_rule" "this" {
  name   = local.resource_name
  region = local.psc_region

  target = local.service_attachment_uri
  // An empty load_balancing_scheme is required for PSC endpoints.
  load_balancing_scheme = ""
  network               = local.vpc_name
  ip_address            = google_compute_address.this.id
  // The endpoint lives in the service attachment's region, which may differ from the
  // region of this environment's workloads; global access ensures they can always reach it.
  allow_psc_global_access = true
  // If the producer closes the connection, the endpoint must be recreated to reconnect.
  recreate_closed_psc = true
  labels              = local.labels

  lifecycle {
    // The wildcard DNS record for the gateway's service domain (see dns.tf) can only live in
    // this network's internal zone if the gateway's hostnames are rooted in the same domain;
    // otherwise consumer Host headers would never match the gateway's routes. Skipped when the
    // producer publishes no DNS information (non-gateway producers).
    precondition {
      condition     = local.gateway_internal_domain == "" || local.gateway_internal_domain == local.internal_domain
      error_message = "The gateway publishes hostnames under internal domain \"${local.gateway_internal_domain}\" but this network's internal domain is \"${local.internal_domain}\". Both networks must share the same internal domain — set var.internal_subdomain on this network's gcp-network block to match the gateway's network."
    }
  }
}
