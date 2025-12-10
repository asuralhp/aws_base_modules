output "vpc_id" {
  description = "ID of the created test VPC."
  value       = aws_vpc.test.id
}

output "subnet_id" {
  description = "ID of the created test subnet."
  value       = aws_subnet.test.id
}
