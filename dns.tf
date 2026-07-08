locals {
  // The gateway routes by Host header using hostnames of the form "<app>.<service_domain>".
  // A wildcard record under the service domain makes every app hostname resolve to this
  // endpoint. The record lives in this network's internal zone, which is why the internal
  // domains of both networks must match (enforced by the precondition below).
  create_dns_record = local.service_domain != "" && local.internal_domain_zone_id != ""
  dns_record_name   = local.create_dns_record ? "*.${local.service_domain}." : ""
  fqdn              = trimsuffix(local.dns_record_name, ".")
}

resource "google_dns_record_set" "endpoint" {
  count = local.create_dns_record ? 1 : 0

  name         = local.dns_record_name
  managed_zone = local.internal_domain_zone_id
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.this.address]
}

// A wildcard does not cover the domain apex; register the service domain itself as well
// so "http://<service_domain>" also reaches the endpoint.
resource "google_dns_record_set" "endpoint_apex" {
  count = local.create_dns_record ? 1 : 0

  name         = "${local.service_domain}."
  managed_zone = local.internal_domain_zone_id
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.this.address]
}
