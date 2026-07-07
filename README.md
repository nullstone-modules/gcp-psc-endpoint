# gcp-psc-endpoint

Creates a Private Service Connect (PSC) endpoint in this environment's VPC that privately reaches a service published in **another GCP project and network** — no VPC peering, no public exposure.

Pairs with `gcp-gke-psc-gateway` (or any ingress block that outputs `service_attachment_uri`).

## Architecture

```
This VPC (consumer)                            Producer VPC (other project)
App (env region) ─► DNS (<dns_name>.<internal_domain>)
                    └─► PSC Endpoint ───────► Service Attachment ──► Internal ALB / Gateway
                        (producer's region)   (ACCEPT_MANUAL)
```

- Creates a small dedicated subnet (`endpoint_subnet_cidr`, /28 by default) in the
  **service attachment's region** — a PSC endpoint must be co-regional with the attachment,
  which may not match this environment's region.
- Reserves a static internal IP in that subnet and creates a forwarding rule targeting
  the producer's PSC service attachment.
- Optionally registers an A record in the network's internal private DNS zone
  (`<dns_name>.<internal_domain>` → endpoint IP).

## Connections

| Name          | Contract          | Purpose                                                                 |
|---------------|-------------------|-------------------------------------------------------------------------|
| `network`     | `network/gcp/vpc` | VPC, private subnets, and the internal private DNS zone                 |
| `psc-service` | `ingress/gcp/*`   | The producer block publishing the service attachment (`service_attachment_uri`) |

## DNS

Set `dns_name` to register a hostname under the network's internal domain (requires the network's
`internal_subdomain` to be configured). Use `dns_name = "*"` for a wildcard record when the producer
is a gateway that routes to apps by hostname — any `<app>.<internal_domain>` then resolves to the endpoint.

## Connection acceptance

The producer publishes with `ACCEPT_MANUAL`. This environment's GCP **project id must be in the
producer's `consumer_projects` allowlist**, or the endpoint will apply cleanly but sit in `PENDING`
(check the `psc_connection_status` output). Traffic flows only once the status is `ACCEPTED`.

## Cross-region access

The endpoint always lives in the producer's region (a GCP requirement), which may differ from
this environment's region. PSC global access is always enabled so workloads anywhere in the VPC
can reach the endpoint over Google's backbone. When regions differ, traffic physically crosses
regions, so expect inter-region latency.
