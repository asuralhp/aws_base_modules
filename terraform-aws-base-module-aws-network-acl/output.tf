output "aws_network_acl" {
  description = "All attributes from the created Network ACL resource."
  value       = aws_network_acl.this
}

output "aws_network_acl_id" {
  description = "The ID of the Network ACL."
  value       = aws_network_acl.this.id
}

output "aws_network_acl_owner_id" {
  description = "The AWS account ID that owns the Network ACL."
  value       = aws_network_acl.this.owner_id
}

output "aws_network_acl_association_ids" {
  description = "IDs of the Network ACL associations to subnets."
  value       = [for a in aws_network_acl_association.this : a.id]
}
