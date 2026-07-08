data "ns_connection" "network" {
  name     = "network"
  contract = "network/gcp/vpc"
}

locals {
  vpc_name = data.ns_connection.network.outputs.vpc_name

  // Empty strings when the network was created without `internal_subdomain`.
  internal_domain_fqdn    = data.ns_connection.network.outputs.internal_domain_fqdn
  internal_domain_zone_id = data.ns_connection.network.outputs.internal_domain_zone_id
  internal_domain         = trimsuffix(local.internal_domain_fqdn, ".")
}
