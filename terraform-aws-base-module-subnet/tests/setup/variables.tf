variable "vpc_name" {
  description = <<-EOT
    (Required) Friendly name for the test VPC. This will be used as the `Name` tag on the VPC.

    Example: "test-vpc-for-subnet-module"
  EOT
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_name)) > 0
    error_message = "vpc_name must be a non-empty string."
  }
}

variable "vpc_cidr_block" {
  description = <<-EOT
    (Required) The IPv4 CIDR block for the test VPC.

    Example: "10.0.0.0/16"
  EOT
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "vpc_cidr_block must be a valid IPv4 CIDR (e.g. 10.0.0.0/16)."
  }
}

variable "vpc_tags" {
  description = <<-EOT
    (Optional) Map of tags to apply to the test VPC. Recommended to include organizational tags used in your environment.

    Example:
      {
        "hkjc:account-name" = "finance-team-member"
        "hkjc:cost-centre"  = "546.000.626.00"
      }
  EOT
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.vpc_tags) >= 0
    error_message = "vpc_tags must be a map of strings."
  }
}
