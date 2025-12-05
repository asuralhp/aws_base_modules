variable "vpc_name" {
  description = "Name of the test VPC"
  type        = string
  default     = "test-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the test VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_dns_servers" {
  description = "DNS servers for the test VPC"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "vpc_is_multicast" {
  description = "Whether to enable multicast for the test VPC"
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = "Tags to apply to the test VPC"
  type        = map(string)
  default = {
    "Purpose" = "testing"
    "Module"  = "subnet-test-helper"
  }
}
