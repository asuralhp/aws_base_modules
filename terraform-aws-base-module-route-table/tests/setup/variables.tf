variable "vpc_name" {
  type    = string
  default = "test-vpc-for-route-table"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}

variable "vpc_tags" {
  type = map(string)
  default = {
    Purpose = "route-table-module-testing"
  }
}
