variable "endpoint_subnet_cidr" {
  type        = string
  default     = "10.131.0.0/28"
  description = <<EOF
Network range for the dedicated subnet that hosts the PSC endpoint's IP address.
This subnet is created in the service attachment's region, which may differ from the environment's region.
It must not overlap any other subnet in the VPC.
EOF
}
