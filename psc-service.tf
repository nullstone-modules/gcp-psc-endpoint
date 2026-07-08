data "ns_connection" "psc_service" {
  name     = "psc-service"
  contract = "ingress/gcp/*"
}

locals {
  // e.g. projects/<project>/regions/<region>/serviceAttachments/<name>
  service_attachment_uri = data.ns_connection.psc_service.outputs.service_attachment_uri

  // A PSC endpoint must be created in the same region as the service attachment,
  // which may differ from this environment's region.
  psc_region = regex("/regions/([^/]+)/", local.service_attachment_uri)[0]

  // Gateway producers (e.g. gcp-gke-psc-gateway) publish the domain their app hostnames live
  // under ("<dns_name>.<internal_domain>") plus the raw internal domain it was built from.
  // Empty strings when the producer does not publish DNS information.
  gateway_internal_domain = try(data.ns_connection.psc_service.outputs.internal_domain, "")
  service_domain          = try(data.ns_connection.psc_service.outputs.service_domain, "")
}
