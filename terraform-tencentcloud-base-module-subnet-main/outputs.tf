output "subnet_id" {
  description = "Subnet ID"
  value       = tencentcloud_subnet.this.id
}

output "subnet_name" {
  description = "Subnet name"
  value       = tencentcloud_subnet.this.name
}

output "subnet_cidr_block" {
  description = "Subnet CIDR block"
  value       = tencentcloud_subnet.this.cidr_block
}

output "subnet_availability_zone" {
  description = "Availability zone where the subnet resides"
  value       = tencentcloud_subnet.this.availability_zone
}

output "subnet_is_multicast" {
  description = "Whether subnet multicast is enabled"
  value       = tencentcloud_subnet.this.is_multicast
}
