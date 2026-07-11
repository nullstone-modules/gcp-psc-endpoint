variable "endpoint_subnet_cidr" {
  type        = string
  default     = "10.131.0.0/28"
  description = <<EOF
Network range for the dedicated subnet that hosts the PSC endpoint's IP address.
This subnet is created in the service attachment's region, which may differ from the environment's region.
It must not overlap any other subnet in the VPC.
EOF
}

variable "vpc_flow_logs" {
  type = object({
    enabled              = bool
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
  })

  default = {
    enabled              = false
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  description = <<EOF
When specified, enables VPC Flow Logs in all created subnets.
The defaults are set to a balance of forensic value and incurred costs.
The drivers of these costs (in order) are: traffic volume, flow_sampling, aggregation_interval, metadata inclusion.
EOF
}

locals {
  vpc_flow_logs_settings = var.vpc_flow_logs.enabled ? toset([var.vpc_flow_logs]) : []
}
