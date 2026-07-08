output "endpoint_ip" {
  value       = google_compute_address.this.address
  description = "string ||| The internal IP address of the PSC endpoint."
}

output "fqdn" {
  value       = local.fqdn
  description = "string ||| The wildcard private DNS name (\"*.<service_domain>\") registered for this endpoint. Apps behind the gateway resolve as <app-name>.<service_domain>. Empty if no DNS record was created."
}

output "public_urls" {
  value       = local.fqdn != "" ? ["http://${local.fqdn}"] : []
  description = "list(string) ||| URL pattern for reaching apps through this endpoint; replace the * with the app's name."
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
