resource "aws_vpc" "test" {
  cidr_block = var.vpc_cidr_block
  tags       = var.vpc_tags
}

resource "aws_subnet" "a" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 1)
  map_public_ip_on_launch = true
  tags = {
    Name = "test-subnet-a"
  }
}

resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 2)
  map_public_ip_on_launch = true
  tags = {
    Name = "test-subnet-b"
  }
}
