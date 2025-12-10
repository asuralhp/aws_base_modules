variable "vpc_name" {
  type    = string
  default = "test-vpc-for-cidr-reservation"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.2.0.0/16"
}

variable "vpc_tags" {
  type = map(string)
  default = {}
}

variable "availability_zone" {
  type    = string
  default = "ap-east-1a"
}
