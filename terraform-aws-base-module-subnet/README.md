# terraform-aws-base-module-subnet

High-level Terraform module to provision a single AWS Subnet with production-ready
defaults, strong input validation, and clear outputs for composing into larger
network topologies.

This README explains:
- what the module creates
- how the module works and which inputs matter
- example usage (minimal and comprehensive)
- what outputs are produced and how to consume them

Resource docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

**Contents**
- `main.tf` - `aws_subnet` resource and any conditional logic
- `variables.tf` - documented inputs and validations
- `output.tf` - useful outputs referencing the created subnet
- `tests/` - module unit tests (tftest)

## What this module creates
- `aws_subnet.this` — a single AWS Subnet with the configured IPv4 CIDR and any
  optional IPv6 CIDR. The module does not create route tables, IGWs, NAT gateways,
  or other network plumbing; those should be composed by higher-level modules or
  the caller.

## Key features
- Input validation for common mistakes (empty VPC IDs, invalid CIDRs).
- Optional IPv6 support via `ipv6_cidr_block` and IPv6-related flags.
- Subnet-level options such as `map_public_ip_on_launch`, `private_dns_hostname_type_on_launch`,
  `enable_dns64`, and `enable_lni_at_device_index`.
- Explicit support for customer-owned IP pools and Outposts when `map_customer_owned_ip_on_launch`
  is enabled (module will validate required companion arguments).

## Inputs (high level)
- `vpc_id` (required): the VPC where the subnet will be created.
- `cidr_block` (required): IPv4 CIDR for the subnet (e.g. `10.0.1.0/24`).
- `availability_zone` / `availability_zone_id` (optional): pin the subnet to an AZ.
- `map_public_ip_on_launch` (bool): subnet auto-assign public IP for instances.
- `assign_ipv6_address_on_creation` (bool) and `ipv6_cidr_block` (string): enable
  and set an IPv6 allocation for the subnet.
- `tags` (map): tags to apply (recommended: `Name` and `environment`).

See the `variables.tf` for a complete list with validation and examples.

## Outputs
- `aws_subnet_id` — the created subnet ID (use this when wiring other modules).
- `aws_subnet` — the full subnet object as returned by the AWS provider.
- `aws_subnet_arn` — the subnet ARN.
- `aws_subnet_tags_all` — merged tags including provider default tags.
- `aws_subnet_owner_id` — owner account id.
- `aws_subnet_ipv6_cidr_block_association_id` — IPv6 association id (if created).

## Usage examples

Minimal example (create a private subnet):

```hcl
module "subnet" {
  source     = "./terraform-aws-base-module-subnet"
  vpc_id     = "vpc-0123456789abcdef0"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name        = "example-subnet"
    environment = "dev"
  }
}

output "subnet_id" {
  value = module.subnet.aws_subnet_id
}
```

Comprehensive example (IPv6 + custom hostname behavior):

```hcl
module "subnet_comprehensive" {
  source  = "./terraform-aws-base-module-subnet"
  vpc_id  = "vpc-0123456789abcdef0"
  cidr_block = "10.0.2.0/24"

  availability_zone = "us-east-1a"
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block = "2600:1f18:1234:abcd::/64"
  private_dns_hostname_type_on_launch = "resource-name"

  tags = {
    Name = "example-subnet-ipv6"
  }
}
```

Using a provider alias to target a different region:

```hcl
provider "aws" {
  alias  = "eu"
  region = "eu-west-1"
}

module "subnet_eu" {
  source = "./terraform-aws-base-module-subnet"
  providers = { aws = aws.eu }

  # region can also be set via the `region` variable if you prefer
  vpc_id = "vpc-0abcd1234efgh5678"
  cidr_block = "10.1.0.0/24"
  region = "eu-west-1"
  tags = { Name = "eu-subnet" }
}
```

## Testing

This repository includes `tftest` tests under `tests/` that demonstrate typical
module usage. Run tests from the module directory:

```bash
terraform init
terraform test
```

Tests will create and destroy cloud resources — use a disposable account or
confirm credentials before running.

## Notes and best practices
- Deleting a subnet can be delayed by dependent resources (ENIs, Lambda). If you
  expect long deletion times, increase `timeout_delete` when calling the module.
- When `map_customer_owned_ip_on_launch` is enabled, the module requires both
  `customer_owned_ipv4_pool` and `outpost_arn` (validation enforces this).
- Keep the module focused: create route tables, IGWs, or NAT gateways outside
  this module so network composition is explicit and auditable.

## Contribution ideas
- Add `examples/` for typical topologies (public/private pairs, multiple AZs)
- Add an option to create the VPC when `vpc_id` is omitted (convenient but
  increases module scope).

*** End Module README ***
