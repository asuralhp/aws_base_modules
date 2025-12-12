
terraform {
  required_version = ">= 1.10.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_vpc" "test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "example-test-vpc"
    environment = "test"
  }
}

module "subnet" {
  source = "./terraform-aws-base-module-subnet"

  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "example-test-subnet"
    environment = "test"
  }
}

# Route table using the base route-table module
module "route_table" {
  source = "./terraform-aws-base-module-route-table"

  vpc_id = aws_vpc.test.id

  # No external routes for testing to avoid creating internet-facing resources
  # `route` defaults to an empty list in the module, so we omit it here.

  tags = {
    Name = "example-route-table"
  }
}

# Associate the created route table to the subnet (no external routes required)
resource "aws_route_table_association" "subnet_assoc" {
  subnet_id      = module.subnet.aws_subnet_id
  route_table_id = module.route_table.aws_route_table_id
}

# CIDR reservation for testing (no external resources)
module "cidr_reservation" {
  source = "./terraform-aws-base-module-ec2-subnet-cidr-reservation"

  subnet_id        = module.subnet.aws_subnet_id
  cidr_block       = "10.0.1.16/28"
  reservation_type = "explicit"
  description      = "test reservation created by local test.tf"

  tags = {
    Name        = "test-reservation"
    environment = "test"
  }
}

output "reservation_id" {
  description = "CIDR reservation ID created by the test module"
  value       = module.cidr_reservation.aws_ec2_subnet_cidr_reservation_id
}

output "vpc_id" {
  description = "ID of the test VPC created for module testing"
  value       = aws_vpc.test.id
}

output "subnet_id" {
  description = "Subnet ID created by the module"
  value       = module.subnet.aws_subnet_id
}

