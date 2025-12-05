output "vpc_id" {
  description = "ID of the test VPC"
  value       = tencentcloud_vpc.test_vpc.id
}

output "vpc_name" {
  description = "Name of the test VPC"
  value       = tencentcloud_vpc.test_vpc.name
}

output "vpc_cidr_block" {
  description = "CIDR block of the test VPC"
  value       = tencentcloud_vpc.test_vpc.cidr_block
}
