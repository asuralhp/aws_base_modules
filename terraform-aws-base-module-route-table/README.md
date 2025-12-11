# terraform-aws-base-module-route-table

A reusable Terraform module for creating and managing an AWS VPC Route Table, including optional route propagation and a simple, declarative way to add routes to common targets (IGW, NAT GW, TGW, VPC Endpoint, etc.).

---

## What Does This Module Do?

- Creates a single AWS Route Table in the specified VPC and region.
- Optionally adds one or more routes to the table using a compact list-of-objects input.
- Supports targets like Internet Gateway, NAT Gateway, Transit Gateway, VPC Endpoint, VPC Peering, Local/Outposts Gateway, and more.
- Optionally enables route propagation from VPN/Virtual Gateways via `propagating_vgws`.
- Applies user-provided tags to the route table resource.

---

## How It Works

This module wraps the `aws_route_table` resource and uses a `dynamic "route"` block to translate your `route` input list into individual route entries. Each route object must specify exactly one destination (CIDR or Prefix List ID) and exactly one target (IGW, NAT GW, TGW, etc.). Conflicts are avoided by keeping all routes defined in this module, rather than mixing inline routes with separate `aws_route` resources.

### Step-by-Step Flow

1. You provide the `vpc_id`, optional `region`, and optional `tags`.
2. You pass a list of `route` objects, each defining a destination and a single target.
3. The module renders `aws_route_table.this` with the provided routes using Terraform's dynamic blocks.
4. If `propagating_vgws` is set, the route table is configured to propagate routes from the specified virtual gateways.
5. Outputs expose the route table ID, owner, and the full resource object for downstream use.

---

## Resources Created

- `aws_route_table.this`: The Route Table in the provided VPC and region.
  - Includes zero or more inline `route` entries per `route` input.
  - Optionally includes `propagating_vgws` for route propagation.

---

## Usage Examples

### Basic: Public route table with default route to Internet Gateway

```hcl
module "route_table_public" {
  source = "./terraform-aws-base-module-route-table"

  vpc_id = "vpc-0123456789abcdef0"
  tags = {
    Name = "public-rt"
    "hkjc:environment" = "sandbox"
  }

  route = [
    { cidr_block = "0.0.0.0/0", gateway_id = "igw-0123456789abcdef0" }
  ]
}
```

### NAT Gateway: Private route table sending Internet-bound traffic through NAT

```hcl
module "route_table_private" {
  source = "./terraform-aws-base-module-route-table"

  vpc_id = "vpc-0123456789abcdef0"
  tags = {
    Name = "private-rt"
    "hkjc:environment" = "sandbox"
  }

  route = [
    { cidr_block = "0.0.0.0/0", nat_gateway_id = "nat-0123456789abcdef0" }
  ]
}
```

### Transit Gateway: Route 10.0.0.0/8 to TGW

```hcl
module "route_table_tgw" {
  source = "./terraform-aws-base-module-route-table"

  vpc_id = "vpc-0123456789abcdef0"
  route = [
    { cidr_block = "10.0.0.0/8", transit_gateway_id = "tgw-0123456789abcdef0" }
  ]
}
```

### VPC Endpoint: Route to AWS-managed prefix list

```hcl
module "route_table_endpoint" {
  source = "./terraform-aws-base-module-route-table"

  vpc_id = "vpc-0123456789abcdef0"
  route = [
    { destination_prefix_list_id = "pl-0123456789abcdef0", vpc_endpoint_id = "vpce-0123456789abcdef0" }
  ]
}
```

---

## What Is Produced

When you apply this module, it produces:

1. A Route Table in your specified VPC and region.
2. Optional inline routes for your chosen destinations and targets.
3. Optional route propagation from the provided virtual gateways.
4. Terraform outputs for ID, owner ID, and the complete resource object for further reference and association with subnets.

---

## Inputs Explained

- `region`: (Optional) Region where this resource will be managed. Defaults to `ap-east-1`.
- `vpc_id`: (Required) The VPC ID where this route table will be created.
- `route`: (Optional) List of route objects. Each must include exactly one destination and one target.
  - Destinations (one of): `cidr_block`, `destination_prefix_list_id`.
  - Targets (one of): `carrier_gateway_id`, `core_network_arn`, `egress_only_gateway_id`, `gateway_id`, `local_gateway_id`, `nat_gateway_id`, `network_interface_id`, `transit_gateway_id`, `vpc_endpoint_id`, `vpc_peering_connection_id`.
  - Example: `[ { cidr_block = "0.0.0.0/0", gateway_id = "igw-0123456789abcdef0" } ]`.
- `propagating_vgws`: (Optional) List of virtual gateway IDs for route propagation.
- `tags`: (Optional) Map of tags to assign to the route table.

---

## Outputs Explained

- `aws_route_table`: Full `aws_route_table.this` resource object, useful when you need attributes beyond ID.
- `aws_route_table_id`: The ID of the created route table, commonly used to associate subnets.
- `aws_route_table_owner_id`: The AWS account ID that owns the route table.

---

## Requirements

- Terraform >= 1.10.4
- AWS Provider ~> 6.0.0

---

## Provider Configuration

The module accepts a `region` input, but uses your configured AWS provider. Ensure your provider is pointed to the desired region and account.

Example provider configuration:

```hcl
provider "aws" {
  region = "ap-east-1"
}
```

---

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.10.4 |
| aws | ~> 6.25.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 6.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| (none) | - | - |

## Resources

| Name |
|------|
| aws_route_table.this |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | (Optional) Region where this resource will be managed. Defaults to ap-east-1 if not provided. | `string` | `"ap-east-1"` | no |
| vpc_id | (Required) The VPC ID where this route table will be created. | `string` | n/a | yes |
| route | (Optional) A list of route objects to add to the route table. See above for destination/target options. | `list(any)` | `[]` | no |
| propagating_vgws | (Optional) List of virtual gateway IDs for route propagation. | `list(string)` | `[]` | no |
| tags | (Optional) Map of tags to assign to the route table. | `map(string)` | `{}` | no |

