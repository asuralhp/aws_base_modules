resource "aws_vpc" "test" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.vpc_tags, { Name = var.vpc_name })
}

resource "aws_subnet" "test" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, 1)
  availability_zone = var.availability_zone

  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-subnet" })
}
