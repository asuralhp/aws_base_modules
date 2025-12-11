output "aws_subnet" {
  value       = aws_subnet.this
  description = "All values from the AWS subnet resource."
}

output "aws_subnet_id" {
  value       = aws_subnet.this.id
  description = "The ID of the subnet."
}

output "aws_subnet_arn" {
  value       = aws_subnet.this.arn
  description = "The ARN of the subnet."
}

output "aws_subnet_tags_all" {
  value       = aws_subnet.this.tags_all
  description = "All tags assigned to the subnet (including provider default_tags)."
}

output "aws_subnet_owner_id" {
  value       = aws_subnet.this.owner_id
  description = "AWS account ID that owns the subnet."
}


