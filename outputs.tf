output "endpoint_ip" {
  value       = google_compute_address.this.address
  description = "string ||| The internal IP address of the PSC endpoint."
}

output "fqdn" {
  value       = local.fqdn
  description = "string ||| The fully-qualified private DNS name of the PSC endpoint. Empty if no DNS record was created."
}

output "public_urls" {
  value       = local.fqdn != "" ? ["http://${local.fqdn}"] : []
  description = "list(string) ||| URLs to reach the PSC service through this endpoint."
}

output "forwarding_rule_id" {
  value       = google_compute_forwarding_rule.this.id
  description = "string ||| The ID of the forwarding rule serving as the PSC endpoint."
}

output "psc_connection_status" {
  value       = google_compute_forwarding_rule.this.psc_connection_status
  description = <<EOF
string ||| The status of the PSC connection (ACCEPTED, PENDING, CLOSED, ...).
PENDING means this GCP project is not in the producer's consumer allowlist yet.
EOF
}
