variable "region" {
  description = <<-EOT
    (Optional) Region where this resource will be managed.

    Notes:
    - Defaults to the Region set in the provider configuration when not provided.
  EOT
  type        = string
  default     = null
}

variable "vpc_id" {
  description = <<-EOT
    (Required) The ID of the associated VPC.

    Requirements:
    - Must be a non-empty string.
    - Should conform to AWS VPC ID format, e.g. "vpc-0123456789abcdef0".
  EOT
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "vpc_id must be a non-empty string (e.g. 'vpc-0123456789abcdef0')."
  }
}

variable "subnet_ids" {
  description = <<-EOT
    (Optional) A list of Subnet IDs to apply the ACL to.

    Notes:
    - Subnets must be within the provided VPC.
    - Each ID should conform to AWS Subnet ID format, e.g. "subnet-0123456789abcdef0".
  EOT
  type        = list(string)
  default     = []
}

variable "ingress" {
  description = <<-EOT
    (Optional) Specifies ingress rules. Attribute-as-blocks list of objects.

    Each object supports the following keys:
    - from_port (Required): The from port to match.
    - to_port   (Required): The to port to match.
    - rule_no   (Required): Rule number used for ordering.
    - action    (Required): Action to take (allow/deny).
    - protocol  (Required): Protocol to match. If using -1 (all), set from/to port to 0.
    - cidr_block        (Optional): IPv4 CIDR block to match.
    
    - icmp_type         (Optional): ICMP type; default 0.
    - icmp_code         (Optional): ICMP code; default 0.

    Note: Refer to ICMP types/codes: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
  EOT
  type = list(object({
    from_port  = number
    to_port    = number
    rule_no    = number
    action     = string
    protocol   = string
    cidr_block = optional(string)

    icmp_type = optional(number, 0)
    icmp_code = optional(number, 0)
  }))
  default = []
}

variable "egress" {
  description = <<-EOT
    (Optional) Specifies egress rules. Attribute-as-blocks list of objects.

    Each object supports the following keys:
    - from_port (Required): The from port to match.
    - to_port   (Required): The to port to match.
    - rule_no   (Required): Rule number used for ordering.
    - action    (Required): Action to take (allow/deny).
    - protocol  (Required): Protocol to match. If using -1 (all), set from/to port to 0.
    - cidr_block        (Optional): IPv4 CIDR block to match.
    
    - icmp_type         (Optional): ICMP type; default 0.
    - icmp_code         (Optional): ICMP code; default 0.

    Note: Refer to ICMP types/codes: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
  EOT
  type = list(object({
    from_port  = number
    to_port    = number
    rule_no    = number
    action     = string
    protocol   = string
    cidr_block = optional(string)

    icmp_type = optional(number, 0)
    icmp_code = optional(number, 0)
  }))
  default = []
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
