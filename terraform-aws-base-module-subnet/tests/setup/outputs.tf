output "vpc_id" {
  description = "ID of the created test VPC."
  value       = aws_vpc.test.id
}

output "vpc" {
  description = "All attributes of the created test VPC."
  value       = aws_vpc.test
}
