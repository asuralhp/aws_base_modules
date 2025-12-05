variable "vpc_id" {
  description = <<-EOT
    (Required) The ID of the VPC that will contain this subnet.

    Requirements:
    - Must reference an existing AWS VPC in the same account and region where you plan to create the subnet.
    - Must be a non-empty string and conform to the AWS VPC identifier pattern (typically starts with "vpc-").
    - Changing this value after creation will replace the subnet (ForceNew behavior).

    Example: "vpc-0a1b2c3d4e5f67890"
  EOT
  type = string

  validation {
    condition     = length(trim(var.vpc_id)) > 0
    error_message = "The VPC ID must be a non-empty string (e.g. 'vpc-0123456789abcdef0')."
  }

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "Invalid VPC ID format. VPC IDs typically start with 'vpc-'."
  }
}

variable "cidr_block" {
  description = <<-EOT
    (Required) IPv4 CIDR block to assign to the subnet.

    Requirements:
    - Must be a valid IPv4 CIDR notation and contained within the parent VPC CIDR.
    - Must not overlap with other subnets in the same VPC.
    - Changing this value after creation is not supported (ForceNew behavior).

    Example: "10.0.1.0/24"
  EOT
  type = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Invalid CIDR block. Provide a valid IPv4 CIDR (e.g. 10.0.1.0/24)."
  }
}

variable "availability_zone" {
  description = <<-EOT
    (Optional) AWS Availability Zone where the subnet will be created.

    Notes:
    - Provide either `availability_zone` or `availability_zone_id` when you need to pin the subnet to a specific AZ.
    - If omitted, AWS may select an AZ for you.
    - Changing this value after creation may recreate the resource.

    Example: "us-east-1a"
  EOT
  type    = string
  default = null

  validation {
    condition     = var.availability_zone == null || length(trim(var.availability_zone)) > 0
    error_message = "When provided, availability_zone must be a non-empty string (e.g. 'us-east-1a')."
  }
}

variable "availability_zone_id" {
  description = <<-EOT
    (Optional) The Availability Zone ID to use for the subnet (for example: "use1-az1").

    Notes:
    - This is the AZ identifier (AZ ID), not the AZ name. Use it when you need AZ stability across accounts/regions.
    - Provide either `availability_zone` or `availability_zone_id` but not both unless required.
    - Changing this value after creation may recreate the subnet.

    Example: "use1-az1"
  EOT
  type    = string
  default = null

  validation {
    condition     = var.availability_zone_id == null || length(trim(var.availability_zone_id)) > 0
    error_message = "When provided, availability_zone_id must be a non-empty AZ identifier string."
  }
}

variable "map_public_ip_on_launch" {
  description = <<-EOT
    (Optional) If true, instances launched into the subnet will receive a public IPv4 address by default.

    Notes:
    - This setting controls the subnet-level auto-assign public IP behavior.
    - Default is `false` to prefer private-only subnets.
  EOT
  type    = bool
  default = false
}

variable "assign_ipv6_address_on_creation" {
  description = <<-EOT
    (Optional) If true, instances launched into the subnet will be assigned an IPv6 address (when IPv6 is enabled).

    Notes:
    - This requires the VPC to have an associated IPv6 CIDR block and the subnet to be allocated an IPv6 CIDR.
    - Default is `false`.
  EOT
  type    = bool
  default = false
}

variable "ipv6_cidr_block" {
  description = <<-EOT
    (Optional) IPv6 CIDR block to assign to the subnet.

    Notes:
    - When provided, it must be a valid IPv6 CIDR range and within the VPC's IPv6 allocation.
    - Changing this after creation may not be supported depending on AWS capabilities.

    Example: "2600:1f18:1234:abcd::/64"
  EOT
  type    = string
  default = null

  validation {
    condition     = var.ipv6_cidr_block == null || can(cidrhost(var.ipv6_cidr_block, 0))
    error_message = "When provided, ipv6_cidr_block must be valid CIDR notation (IPv6)."
  }
}

variable "private_dns_hostname_type_on_launch" {
  description = <<-EOT
    (Optional) Controls the type of private DNS hostname assigned to EC2 instances at launch.

    Accepted values:
    - "ip-name": hostname based on the private IPv4 address
    - "resource-name": resource-based hostname

    Default: "ip-name"
  EOT
  type    = string
  default = "ip-name"

  validation {
    condition     = can(regex("^(ip-name|resource-name)$", var.private_dns_hostname_type_on_launch))
    error_message = "Invalid value: private_dns_hostname_type_on_launch must be 'ip-name' or 'resource-name'."
  }
}

variable "enable_dns64" {
  description = <<-EOT
    (Optional) Enable DNS64 on the subnet.

    Notes:
    - DNS64 is used for IPv6-only clients to communicate with IPv4 servers when combined with NAT64.
    - Default: `false`.
  EOT
  type    = bool
  default = false
}

variable "customer_owned_ipv4_pool" {
  description = <<-EOT
    (Optional) The ID of a customer-owned IPv4 address pool to use for instances in this subnet.

    Notes:
    - Provide the customer-owned pool identifier when using Amazon EC2 IP address management features.
    - Must be a valid pool ID or `null`.
  EOT
  type    = string
  default = null

  validation {
    condition     = var.customer_owned_ipv4_pool == null || length(trim(var.customer_owned_ipv4_pool)) > 0
    error_message = "When provided, customer_owned_ipv4_pool must be a non-empty string identifying the pool."
  }
}

variable "outpost_arn" {
  description = <<-EOT
    (Optional) ARN of the AWS Outpost to associate with the subnet.

    Notes:
    - Only required when placing resources on an Outpost subnet.
    - Must be a valid Outpost ARN when provided.
  EOT
  type    = string
  default = null

  validation {
    condition     = var.outpost_arn == null || can(regex("^arn:aws(:[a-z0-9-]+)*:outposts:[^:]+:[0-9]{12}:outpost/.+", var.outpost_arn))
    error_message = "When provided, outpost_arn must be a valid Outpost ARN (arn:aws:outposts:...)."
  }
}

variable "tags" {
  description = <<-EOT
    (Required) Map of tags to apply to the subnet.

    Requirements:
    - Must be a map of string keys to string values.
    - At least one tag is required (recommended to include 'Name' and organizational tags such as environment/team).
    - Tag keys must be 1-127 characters; tag values must be 0-255 characters per AWS limits.
    - Keys should avoid disallowed characters; using lowercase letters, numbers, colon, dash, underscore, and dot is recommended.

    Example:
    {
      Name        = "example-subnet"
      environment = "dev"
    }
  EOT
  type = map(string)

  validation {
    condition     = length(var.tags) > 0
    error_message = "At least one tag is required (recommend including 'Name' and environment/team tags)."
  }

  validation {
    condition = alltrue([
      for k in keys(var.tags) : can(length(k) <= 127)
    ])
    error_message = "All tag keys must be 127 characters or fewer."
  }

  validation {
    condition = alltrue([
      for v in values(var.tags) : can(length(v) <= 255)
    ])
    error_message = "All tag values must be 255 characters or fewer."
  }

  validation {
    condition = alltrue([
      for k in keys(var.tags) : can(regex("^[a-zA-Z0-9:_.-]+$", k))
    ])
    error_message = "Tag keys may only contain letters, numbers, colon, underscore, dot, and dash."
  }
}

variable "enable_lni_at_device_index" {
  description = <<-EOT
    (Optional) Device index to enable local network interfaces on the subnet.

    Notes:
    - When set, indicates the device position for local network interfaces in this subnet (for example, 1 -> eth1).
    - Must be a positive integer when provided.
  EOT
  type    = number
  default = null

  validation {
    condition     = var.enable_lni_at_device_index == null || (var.enable_lni_at_device_index >= 1)
    error_message = "enable_lni_at_device_index must be a positive integer when provided."
  }
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  description = <<-EOT
    (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records.

    Default: `false`.
  EOT
  type    = bool
  default = false
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = <<-EOT
    (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS A records.

    Default: `false`.
  EOT
  type    = bool
  default = false
}

variable "ipv6_native" {
  description = <<-EOT
    (Optional) Indicates whether to create an IPv6-only subnet.

    Default: `false`.
  EOT
  type    = bool
  default = false
}

variable "map_customer_owned_ip_on_launch" {
  description = <<-EOT
    (Optional) Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address.

    Notes:
    - When set to `true`, `customer_owned_ipv4_pool` and `outpost_arn` must also be provided.
    - Default: `false`.
  EOT
  type    = bool
  default = false

  validation {
    condition = !var.map_customer_owned_ip_on_launch || (var.customer_owned_ipv4_pool != null && var.outpost_arn != null)
    error_message = "When map_customer_owned_ip_on_launch is true, customer_owned_ipv4_pool and outpost_arn must be provided."
  }
}

