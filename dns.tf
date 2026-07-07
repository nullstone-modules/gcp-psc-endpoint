locals {
  // The network's internal zone dns_name carries a trailing dot (e.g. "acme.internal.").
  create_dns_record = var.dns_name != "" && local.internal_domain_zone_id != ""
  dns_record_name   = local.create_dns_record ? "${var.dns_name}.${local.internal_domain_fqdn}" : ""
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
