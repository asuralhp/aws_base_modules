output "aws_ec2_transit_gateway" {
  description = "All attributes from the created EC2 Transit Gateway resource."
  value       = aws_ec2_transit_gateway.this
}

output "aws_ec2_transit_gateway_id" {
  description = "ID of the EC2 Transit Gateway."
  value       = aws_ec2_transit_gateway.this.id
}

output "aws_ec2_transit_gateway_arn" {
  description = "ARN of the EC2 Transit Gateway."
  value       = aws_ec2_transit_gateway.this.arn
}

output "aws_ec2_transit_gateway_owner_id" {
  description = "AWS account ID that owns the EC2 Transit Gateway."
  value       = aws_ec2_transit_gateway.this.owner_id
}
