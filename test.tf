provider "aws" {
	region = "ap-east-1"
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

output "vpc_id" {
	description = "ID of the test VPC created for module testing"
	value       = aws_vpc.test.id
}

output "subnet_id" {
	description = "Subnet ID created by the module"
	value       = module.subnet.aws_subnet_id
}

