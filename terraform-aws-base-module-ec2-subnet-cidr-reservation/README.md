# terraform-aws-base-module-ec2_subnet_cidr_reservation

A reusable Terraform module for creating and managing AWS EC2 Subnet CIDR Reservations. This README was enriched using the prompt: "help me enrich and expand my readme explaining what the module does, how it works along with usage examples and if helpful, help the enduser understand what is created, and explain what is produced".

---

## What Does This Module Do?

- Creates an EC2 Subnet CIDR reservation in a specified subnet and region.
- Validates key inputs (CIDR syntax and non-empty IDs) to catch common mistakes early.
- Exposes outputs for the reservation’s ID and full attributes.

---

## How It Works

This module is a thin wrapper around `aws_ec2_subnet_cidr_reservation`. You specify the target subnet, the CIDR to reserve, and the reservation type. The module configures the resource with your optional description and returns useful outputs for downstream use.

### Step-by-Step Flow

1. Provide `subnet_id`, `cidr_block`, and `reservation_type`; optionally set `description` and `region`.
2. The module creates `aws_ec2_subnet_cidr_reservation.this` with those values.
3. Terraform outputs expose the reservation’s `id` and the full resource object.

---

## Resources Created

- `aws_ec2_subnet_cidr_reservation.this`: EC2 Subnet CIDR reservation for the given subnet and CIDR.

---

## Usage Examples

### Basic: Reserve a /28 inside a subnet

```hcl
module "cidr_reservation_basic" {
  source = "./terraform-aws-base-module-ec2-subnet-cidr-reservation"

  subnet_id        = "subnet-0123456789abcdef0"
  cidr_block       = "10.0.1.0/28"
  reservation_type = "explicit"
  description      = "Reserved for dev worker nodes (ticket: ABC-123)"
}
```

### With region override

```hcl
module "cidr_reservation_regional" {
  source = "./terraform-aws-base-module-ec2-subnet-cidr-reservation"

  region           = "ap-east-1"
  subnet_id        = "subnet-0123456789abcdef0"
  cidr_block       = "10.0.2.0/27"
  reservation_type = "explicit"
}
```

---

## What Is Produced

When you apply this module, it produces:

1. An EC2 Subnet CIDR Reservation bound to your specified subnet and CIDR.
2. Optional human-readable description persisted on the reservation.
3. Terraform outputs for the reservation ID and full resource attributes.

---

## Inputs Explained

- `region`: (Optional) AWS region where the reservation should be created. Defaults to `ap-east-1`.
- `subnet_id`: (Required) The ID of the subnet in which the CIDR reservation will be created. Must be non-empty.
  - Example: `"subnet-0123456789abcdef0"`.
- `cidr_block`: (Required) IPv4 CIDR block to reserve inside the subnet.
  - Example: `"10.0.1.0/28"`.
- `reservation_type`: (Required) The type of reservation to create (e.g., `"explicit"`). Must be non-empty.
  - Example: `"explicit"`.
- `description`: (Optional) Description for the CIDR reservation.
  - Example: `"Reserved for dev worker nodes (ticket: ABC-123)"`.
- `tags`: (Optional) Map of tags to apply to the reservation.
  - Example: `{ Name = "example-reservation", environment = "test" }`.

---

## Outputs Explained

- `aws_ec2_subnet_cidr_reservation`: Full resource object, useful when you need attributes beyond the ID.
- `aws_ec2_subnet_cidr_reservation_id`: ID of the created CIDR reservation.

---

## Requirements

- Terraform >= 1.10.4
- AWS Provider ~> 6.0.0

---

## Provider Configuration

Ensure your AWS provider is configured for the intended region and account.

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
| aws_ec2_subnet_cidr_reservation.this |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | (Optional) AWS region where this resource should be created. Defaults to ap-east-1 when not provided. | `string` | `"ap-east-1"` | no |
| subnet_id | (Required) The ID of the subnet in which the CIDR reservation will be created. | `string` | n/a | yes |
| cidr_block | (Required) IPv4 CIDR block to reserve inside the subnet. | `string` | n/a | yes |
| reservation_type | (Required) The type of reservation to create for the CIDR. | `string` | n/a | yes |
| description | (Optional) Description for the CIDR reservation. | `string` | `null` | no |
| tags | (Optional) Map of tags to apply to the CIDR reservation. | `map(string)` | `{}` | no |

