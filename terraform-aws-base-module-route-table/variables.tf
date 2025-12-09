variable "region" {
  description = "(Optional) Region where this resource will be managed. If null, the provider default region is used."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "(Required) The VPC ID where this route table will be created."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "vpc_id must be a non-empty string (e.g. 'vpc-0123456789abcdef0')."
  }
}

variable "route" {
  description = <<-EOT
    (Optional) A list of route objects to add to the route table.

    This argument is processed in attribute-as-blocks mode.

    One of the following destination arguments must be supplied per route:

    - `cidr_block` - (Required) The CIDR block of the route.
    - `ipv6_cidr_block` - (Optional) The IPv6 CIDR block of the route.
    - `destination_prefix_list_id` - (Optional) The ID of a managed prefix list destination of the route.

    One of the following target arguments must be supplied per route:

    - `carrier_gateway_id` - (Optional) Identifier of a carrier gateway (Wavelength Zone only).
    - `core_network_arn` - (Optional) The ARN of a core network.
    - `egress_only_gateway_id` - (Optional) Identifier of a VPC Egress Only Internet Gateway.
    - `gateway_id` - (Optional) Identifier of a VPC internet gateway, virtual private gateway, or local.
    - `local_gateway_id` - (Optional) Identifier of an Outpost local gateway.
    - `nat_gateway_id` - (Optional) Identifier of a VPC NAT gateway.
    - `network_interface_id` - (Optional) Identifier of an EC2 network interface.
    - `transit_gateway_id` - (Optional) Identifier of an EC2 Transit Gateway.
    - `vpc_endpoint_id` - (Optional) Identifier of a VPC Endpoint.
    - `vpc_peering_connection_id` - (Optional) Identifier of a VPC peering connection.

    Note: the default route mapping the VPC's CIDR block to "local" is created implicitly
    and cannot be specified. Do not mix inline `route` blocks with separate `aws_route`
    resources for the same route table; doing so will cause conflicts.

    Example:
    [
      { cidr_block = "0.0.0.0/0", gateway_id = "igw-0123456789abcdef0" }
    ]
  EOT
  type    = list(any)
  default = []
}

variable "propagating_vgws" {
  description = "(Optional) List of virtual gateway IDs for route propagation."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the route table."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([for k in keys(var.tags) : can(regex("^[a-zA-Z0-9:_.-]+$", k))])
    error_message = "Tag keys may only contain letters, numbers, colon, underscore, dot, and dash."
  }
}
