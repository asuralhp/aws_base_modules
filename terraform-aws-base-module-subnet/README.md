# terraform-aws-base-module-subnet
AWS subnet module for Terraform. This module provisions a single subnet in a target VPC.

Resource docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.10.4 |
| aws | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| aws_subnet.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | (Required) The VPC ID that hosts the subnet. | `string` | n/a | yes |
| cidr_block | (Required) The IPv4 CIDR block for the subnet. | `string` | n/a | yes |
| availability_zone | (Optional) The Availability Zone for the subnet. | `string` | `null` | no |
| availability_zone_id | (Optional) The AZ ID for the subnet (e.g., use1-az1). | `string` | `null` | no |
| map_public_ip_on_launch | (Optional) Assign a public IPv4 address to launched instances. | `bool` | `false` | no |
| region | (Optional) Region where the resource will be managed. Use provider alias to override provider default. | `string` | `null` | no |
| assign_ipv6_address_on_creation | (Optional) Assign IPv6 address to instances launched into the subnet. | `bool` | `false` | no |
| ipv6_cidr_block | (Optional) The IPv6 CIDR block for the subnet. | `string` | `null` | no |
| private_dns_hostname_type_on_launch | (Optional) Type of hostname for EC2 instances in the subnet. Valid values: ip-name or resource-name. | `string` | `"ip-name"` | no |
| enable_dns64 | (Optional) Enable DNS64 for the subnet. | `bool` | `false` | no |
| customer_owned_ipv4_pool | (Optional) The customer-owned IPv4 pool for connected devices. | `string` | `null` | no |
| outpost_arn | (Optional) The ARN of the Outpost to associate with the subnet. | `string` | `null` | no |
| tags | (Required) A map of tags to assign to the subnet. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws_subnet | All values from the AWS subnet resource. |
| aws_subnet_id | The ID of the subnet. |
| aws_subnet_arn | The ARN of the subnet. |
| aws_subnet_tags_all | All tags assigned to the subnet (including provider default_tags). |
| aws_subnet_owner_id | AWS account ID that owns the subnet. |
| aws_subnet_ipv6_cidr_block_association_id | The association ID for the IPv6 CIDR block (if assigned). |

## Usage

```hcl
module "subnet" {
  source  = "./terraform-aws-base-module-subnet"
  vpc_id  = "vpc-0123456789abcdef0"
  cidr_block = "10.0.1.0/24"

  availability_zone               = "us-east-1a"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  # Optional: adjust deletion timeout when subnets are associated with Lambda functions
  # timeout_delete = "45m"

  tags = {
    Name        = "example-subnet"
    environment = "dev"
  }
}
```

## Notes

- Timeouts: The AWS provider sets sensible defaults (create=10m, delete=20m). When subnets are used by AWS Lambda, deletion can take significantly longer — set `timeout_delete = "45m"` to be safe for those cases.
- When `map_customer_owned_ip_on_launch` is enabled, both `customer_owned_ipv4_pool` and `outpost_arn` must be provided.
- For subnets in secondary VPC CIDR blocks (created with `aws_vpc_ipv4_cidr_block_association`), reference that resource's `vpc_id` to ensure correct dependency ordering.
