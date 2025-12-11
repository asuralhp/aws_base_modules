variable "vpc_cidr_block" {
  type        = string
  description = "CIDR for test VPC"
}

variable "vpc_tags" {
  type        = map(string)
  description = "Tags for test VPC"
  default     = {}
}
