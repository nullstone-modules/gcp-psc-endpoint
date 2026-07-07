variable "dns_name" {
  type        = string
  default     = ""
  description = <<EOF
Hostname to register in the network's internal private DNS zone, pointing at the PSC endpoint.
The resulting FQDN is "<dns_name>.<internal_domain>" (e.g. "gateway.acme.internal").
Use "*" to register a wildcard record so any hostname under the internal domain resolves to the endpoint;
this is the typical choice when the producer is a gateway routing to apps by hostname.
Leave blank to skip DNS registration.
This requires the network to be configured with an internal subdomain.
EOF
}

variable "endpoint_subnet_cidr" {
  type        = string
  default     = "10.131.0.0/28"
  description = <<EOF
Network range for the dedicated subnet that hosts the PSC endpoint's IP address.
This subnet is created in the service attachment's region, which may differ from the environment's region.
It must not overlap any other subnet in the VPC.
EOF
}
