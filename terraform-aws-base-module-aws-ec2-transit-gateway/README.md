# terraform-aws-base-module-aws-ec2-transit-gateway

A reusable Terraform module for creating and managing an AWS EC2 Transit Gateway (TGW). This README follows the prompt: "help me enrich and expand my readme explaining what the module does, how it works along with usage examples and if helpful, help the enduser understand what is created, and explain what is produced".

---

## What Does This Module Do?

- Creates an EC2 Transit Gateway with opinionated defaults and configurable options.
- Supports common toggles such as auto-accepting shared attachments, default route table association/propagation, DNS support, multicast support, and TGW CIDR blocks.
- Applies tags and exposes key outputs for downstream referencing.

---

## How It Works

This module wraps `aws_ec2_transit_gateway` and translates your inputs into the TGW resource configuration. Most toggles are strings that accept `enable`/`disable`, mirroring AWS provider expectations.

### Step-by-Step Flow

1. Provide optional `description`, ASN, and capability toggles (auto-accept, association/propagation, DNS, multicast).
2. Optionally provide `transit_gateway_cidr_blocks` for routing domains.
3. The module creates `aws_ec2_transit_gateway.this` with your inputs.
4. Outputs expose identifiers and ownership details for use in attachments and route tables.

---

## Resources Created

- `aws_ec2_transit_gateway.this`: The EC2 Transit Gateway resource.

---

## Usage Examples

### Basic TGW with defaults

```hcl
module "tgw_basic" {
  source = "./terraform-aws-base-module-aws-ec2-transit-gateway"

  description = "Core TGW"
  dns_support = "enable"
}
```

### TGW with custom ASN and CIDR blocks

```hcl
module "tgw_advanced" {
  source = "./terraform-aws-base-module-aws-ec2-transit-gateway"

  description                 = "TGW for shared services"
  amazon_side_asn             = 64520
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                 = "enable"
  multicast_support           = "disable"
  transit_gateway_cidr_blocks = [
    "10.100.0.0/16",
    "10.200.0.0/16"
  ]

  tags = {
    Name = "shared-services-tgw"
  }
}
```

---

## What Is Produced

When you apply this module, it produces:

1. An EC2 Transit Gateway configured per your inputs.
2. Optional routing CIDR blocks attached to the TGW.
3. Terraform outputs for the TGW ID, ARN, and owner ID for downstream usage (attachments, route tables, etc.).

---

## Inputs Explained

- `region`: (Optional) Region where this resource will be managed. Defaults to provider region if not set here.
- `description`: (Optional) A description for the TGW.
- `amazon_side_asn`: (Optional) The ASN for the Amazon side of BGP sessions.
- `auto_accept_shared_attachments`: (Optional) Whether attachments are automatically accepted (`enable`/`disable`).
- `default_route_table_association`: (Optional) Auto-associate attachments to default association route table (`enable`/`disable`).
- `default_route_table_propagation`: (Optional) Auto-propagate routes to default propagation route table (`enable`/`disable`).
- `dns_support`: (Optional) Whether DNS support is enabled (`enable`/`disable`).
- `multicast_support`: (Optional) Whether multicast is enabled (`enable`/`disable`).
- `transit_gateway_cidr_blocks`: (Optional) List of IPv4/IPv6 CIDR blocks to attach to the TGW.
- `tags`: (Optional) Map of tags to assign to the TGW.

---

## Outputs Explained

- `aws_ec2_transit_gateway`: Full TGW resource object.
- `aws_ec2_transit_gateway_id`: TGW ID.
- `aws_ec2_transit_gateway_arn`: TGW ARN.
- `aws_ec2_transit_gateway_owner_id`: AWS account ID that owns the TGW.

---

## Requirements

- Terraform >= 1.10.4
- AWS Provider ~> 6.0.0

---

## Provider Configuration

Ensure your AWS provider is set to the intended region/account.

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
| aws_ec2_transit_gateway.this |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | (Optional) Region where this resource will be managed. | `string` | `null` | no |
| description | (Optional) A description for the EC2 Transit Gateway. | `string` | `null` | no |
| amazon_side_asn | (Optional) The Amazon-side ASN for BGP. | `number` | `null` | no |
| auto_accept_shared_attachments | (Optional) Auto-accept shared attachments. | `string` | `"disable"` | no |
| default_route_table_association | (Optional) Default route table association. | `string` | `"enable"` | no |
| default_route_table_propagation | (Optional) Default route table propagation. | `string` | `"enable"` | no |
| dns_support | (Optional) DNS support. | `string` | `"enable"` | no |
| multicast_support | (Optional) Multicast support. | `string` | `"disable"` | no |
| transit_gateway_cidr_blocks | (Optional) TGW CIDR blocks. | `list(string)` | `[]` | no |
| tags | (Optional) Map of tags to assign. | `map(string)` | `{}` | no |
