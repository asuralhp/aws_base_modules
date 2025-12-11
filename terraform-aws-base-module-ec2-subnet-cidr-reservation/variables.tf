variable "region" {
  description = <<-EOT
    (Optional) AWS region where this resource should be created.

    Notes:
    - Defaults to ap-east-1 when not provided.
  EOT
  type        = string
  default     = "ap-east-1"
}

variable "subnet_id" {
  description = <<-EOT
    (Required) The ID of the subnet in which the CIDR reservation will be created.

    Requirements:
    - Must reference an existing AWS subnet in the same account and region where the
      module is executed.
    - Must be a non-empty string and conform to the AWS subnet id pattern (e.g. "subnet-0123abcd").
    - Changing this value after creation will replace the reservation (ForceNew behavior).
  
    Example: "subnet-0123456789abcdef0"
  EOT
  type        = string

  validation {
    condition     = length(trimspace(var.subnet_id)) > 0
    error_message = "subnet_id must be a non-empty string (e.g. 'subnet-0123456789abcdef0')."
  }
}

variable "cidr_block" {
  description = <<-EOT
    (Required) IPv4 CIDR block to reserve inside the subnet.

    Requirements:
    - Must be a valid IPv4 CIDR notation (for example: "10.0.1.0/28").
    - Must be contained within the parent subnet's CIDR block.
    - This value cannot be changed after creation (ForceNew behavior for the reservation).
  
    Example: "10.0.1.0/28"
  EOT
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be a valid IPv4 CIDR (for example: 10.0.1.0/28)."
  }
}

variable "description" {
  description = <<-EOT
    (Optional) Description for the CIDR reservation.

    Notes:
    - Helpful to record purpose, owner, or tracking ticket information.
    - Max length enforced by AWS; keep descriptions concise.
  
  Example: "Reserved for dev worker nodes (ticket: ABC-123)"
  EOT
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(trimspace(var.description)) > 0
    error_message = "When provided, description must be a non-empty string."
  }
}

variable "tags" {
  description = <<-EOT
    (Optional) Map of tags to apply to the CIDR reservation.

    Best practices:
    - Include a `Name` tag and organizational tags such as `environment` or `team`.
    - Tag keys: 1-127 chars. Tag values: 0-255 chars. Avoid disallowed characters.
  
    Example:
    {
      Name        = "example-reservation"
      environment = "test"
    }
  EOT
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.tags) : can(regex("^[a-zA-Z0-9:_.-]+$", k))])
    error_message = "Tag keys may only contain letters, numbers, colon, underscore, dot, and dash."
  }
}

variable "reservation_type" {
  description = <<-EOT
    (Required) The type of reservation to create for the CIDR.

    Notes:
    - Common values include "explicit" (reserve the exact provided CIDR) or
      provider-specific reservation types. This value is required by the
      AWS API for subnet CIDR reservations.
    
    Example: "explicit"
  EOT
  type        = string

  validation {
    condition     = length(trimspace(var.reservation_type)) > 0
    error_message = "reservation_type must be a non-empty string (e.g. 'explicit')."
  }
}
