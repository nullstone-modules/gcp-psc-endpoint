// The endpoint's IP must come from a subnet in the service attachment's region.
// The network module only creates subnets in the environment's region, so a small
// dedicated subnet is created here to host the endpoint.
resource "google_compute_subnetwork" "endpoint" {
  name          = "${local.resource_name}-psc"
  ip_cidr_range = var.endpoint_subnet_cidr
  network       = local.vpc_name
  region        = local.psc_region
}
