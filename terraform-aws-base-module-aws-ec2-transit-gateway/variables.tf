variable "region" {
  description = <<-EOT
        (Optional) Region where this resource will be managed.

        Notes:
        - Defaults to "ap-east-1" if not provided.
        - If not set, will use the Region set in the provider configuration.
    EOT
  type        = string
  default     = "ap-east-1"
}

variable "description" {
  description = <<-EOT
    (Optional) A description for the EC2 Transit Gateway.

    Best practices:
    - Include purpose, owner, or tracking ticket information.
    - Keep concise; AWS enforces maximum length.
  EOT
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(trimspace(var.description)) > 0
    error_message = "When provided, description must be a non-empty string."
  }
}

variable "amazon_side_asn" {
  description = <<-EOT
    (Optional) The private Autonomous System Number (ASN) for the Amazon side of a BGP session.

    Notes:
    - Valid values: 64512 to 65534 for 16-bit ASN, or 1 to 2147483647 for 32-bit ASN.
    - Defaults to 64512 if not specified by AWS.
  EOT
  type        = number
  default     = null
}

variable "auto_accept_shared_attachments" {
  description = <<-EOT
    (Optional) Whether resource attachments are automatically accepted.

    Valid values:
    - "enable" or "disable".
  EOT
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["enable", "disable"], var.auto_accept_shared_attachments)
    error_message = "auto_accept_shared_attachments must be either 'enable' or 'disable'."
  }
}

variable "default_route_table_association" {
  description = <<-EOT
    (Optional) Whether resource attachments are automatically associated with the default association route table.

    Valid values: "enable" or "disable".
  EOT
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["enable", "disable"], var.default_route_table_association)
    error_message = "default_route_table_association must be either 'enable' or 'disable'."
  }
}

variable "default_route_table_propagation" {
  description = <<-EOT
    (Optional) Whether resource attachments automatically propagate routes to the default propagation route table.

    Valid values: "enable" or "disable".
  EOT
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["enable", "disable"], var.default_route_table_propagation)
    error_message = "default_route_table_propagation must be either 'enable' or 'disable'."
  }
}

variable "dns_support" {
  description = <<-EOT
    (Optional) Indicates whether DNS support is enabled for the EC2 Transit Gateway.

    Valid values: "enable" or "disable".
  EOT
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["enable", "disable"], var.dns_support)
    error_message = "dns_support must be either 'enable' or 'disable'."
  }
}

variable "multicast_support" {
  description = <<-EOT
    (Optional) Indicates whether multicast is enabled on the transit gateway.

    Valid values: "enable" or "disable".
  EOT
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["enable", "disable"], var.multicast_support)
    error_message = "multicast_support must be either 'enable' or 'disable'."
  }
}

variable "transit_gateway_cidr_blocks" {
  description = <<-EOT
    (Optional) List of IPv4 or IPv6 CIDR blocks for transit gateway.

    Notes:
    - Must be valid CIDR blocks.
  EOT
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.transit_gateway_cidr_blocks : can(cidrhost(c, 0))])
    error_message = "All entries in transit_gateway_cidr_blocks must be valid CIDR blocks."
  }
}

variable "tags" {
  description = <<-EOT
    (Optional) A map of tags to assign to the resource.

    Best practices:
    - Provide a `Name` tag and organizational tags such as `environment` or `team`.
    - If provider `default_tags` are configured, matching keys here will override provider-level values.
  EOT
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.tags) : can(regex("^[a-zA-Z0-9:_.-]+$", k))])
    error_message = "Tag keys may only contain letters, numbers, colon, underscore, dot, and dash."
  }
}
