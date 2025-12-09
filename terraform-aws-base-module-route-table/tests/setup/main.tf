resource "aws_vpc" "test" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.vpc_tags, { Name = var.vpc_name })
}

