# terraform-aws-base-module-route-table

Terraform module to create an AWS Route Table and manage in-line routes.

Features:
- Create a route table in a given VPC
- Manage in-line `route` blocks (attribute-as-blocks style)
- Configure `propagating_vgws` and `tags`

Usage
-----
Basic example:

```hcl
module "route_table" {
  source = "./terraform-aws-base-module-route-table"

  vpc_id = "vpc-0123456789abcdef0"

  route = [
    { cidr_block = "0.0.0.0/0", gateway_id = "igw-0123456789abcdef0" }
  ]

  tags = {
    Name = "example-rt"
  }
}
```

Inputs
------
- `region` - (Optional) AWS region to manage the resource in. Defaults to provider region.
- `vpc_id` - (Required) VPC ID where the route table will be created.
- `route` - (Optional) List of route objects (see Terraform `aws_route_table` docs).
- `propagating_vgws` - (Optional) List of virtual gateway IDs for propagation.
- `tags` - (Optional) Map of tags to apply.

Outputs
-------
- `aws_route_table` - All attributes from the created `aws_route_table` resource.
- `aws_route_table_id` - ID of the created route table.
- `aws_route_table_owner_id` - AWS account ID that owns the route table.

Notes
-----
- Do not mix inline `route` blocks with separate `aws_route` resources for the same route table.
