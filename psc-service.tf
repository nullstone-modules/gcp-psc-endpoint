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
}
