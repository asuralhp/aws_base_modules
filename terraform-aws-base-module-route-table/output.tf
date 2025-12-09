output "aws_route_table" {
  description = "All attributes from the AWS route table resource."
  value       = aws_route_table.this
}

output "aws_route_table_id" {
  description = "The ID of the created route table."
  value       = aws_route_table.this.id
}

output "aws_route_table_owner_id" {
  description = "AWS account ID that owns the route table."
  value       = aws_route_table.this.owner_id
}
