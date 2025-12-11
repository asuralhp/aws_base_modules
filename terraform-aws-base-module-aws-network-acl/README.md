# terraform-aws-base-module-aws_network_acl

A reusable Terraform module for creating and managing an AWS Network ACL (NACL) and associating it with one or more subnets. This README is based on the prompt: "help me enrich and expand my readme explaining what the module does, how it works along with usage examples and if helpful, help the enduser understand what is created, and explain what is produced".

---

## What Does This Module Do?

- Creates an AWS Network ACL in a given VPC and optional region.
- Configures ingress and egress rules using attribute-as-blocks list inputs.
- Associates the created NACL with one or more subnets.
- Applies tags, integrating with provider `default_tags` behavior.

---

## How It Works

This module wraps `aws_network_acl` and `aws_network_acl_association`. You provide the VPC ID, optional region, and rule lists for ingress/egress. The module renders the rules via Terraform dynamic blocks and associates the ACL with each provided subnet.

### Step-by-Step Flow

1. Provide `vpc_id`, optional `region`, and any `tags`.
2. Specify `ingress` and/or `egress` rule lists, each item defining ports, protocol, CIDRs, action, and rule number.
3. The module creates `aws_network_acl.this` with those rules.
4. The module creates `aws_network_acl_association.this` for each subnet in `subnet_ids`.
5. Outputs expose the ACL ID, owner, and association IDs.

---

## Resources Created

- `aws_network_acl.this`: The Network ACL with ingress and egress rules.
- `aws_network_acl_association.this`: One association per provided subnet.

---

## Usage Examples

### Basic: Allow all inbound/outbound and associate to two subnets

```hcl
module "nacl_basic" {
  source = "./terraform-aws-base-module-aws_network_acl"

  vpc_id     = "vpc-0123456789abcdef0"
  subnet_ids = ["subnet-aaa", "subnet-bbb"]

  ingress = [
    { rule_no = 100, protocol = "-1", action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }
  ]

  egress = [
    { rule_no = 100, protocol = "-1", action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }
  ]

  tags = { Name = "example-nacl" }
}
```

 

---

## What Is Produced

When you apply this module, it produces:

1. A Network ACL with your configured ingress and egress rules.
2. Associations that attach the ACL to the specified subnets.
3. Terraform outputs for the ACL ID, owner ID, and association IDs.

---

## Inputs Explained

- `region`: (Optional) Region where this resource will be managed. Defaults to provider region if not set here.
- `vpc_id`: (Required) The ID of the associated VPC.
- `subnet_ids`: (Optional) A list of Subnet IDs to apply the ACL to.
- `ingress`: (Optional) Ingress rules list (attribute-as-blocks). Keys: `from_port`, `to_port`, `rule_no`, `action`, `protocol`, optional `cidr_block`, `icmp_type`, `icmp_code`.
- `egress`: (Optional) Egress rules list (attribute-as-blocks). Same keys as ingress.
- `tags`: (Optional) Map of tags to assign to the resource.

---

## Outputs Explained

- `aws_network_acl`: Full `aws_network_acl.this` resource object.
- `aws_network_acl_id`: The ID of the Network ACL.
- `aws_network_acl_owner_id`: The AWS account ID that owns the Network ACL.
- `aws_network_acl_association_ids`: IDs of the Network ACL associations to subnets.

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
| aws_network_acl.this |
| aws_network_acl_association.this |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | (Optional) Region where this resource will be managed. Defaults to the provider region. | `string` | `null` | no |
| vpc_id | (Required) The ID of the associated VPC. | `string` | n/a | yes |
| subnet_ids | (Optional) A list of Subnet IDs to apply the ACL to. | `list(string)` | `[]` | no |
| ingress | (Optional) Specifies ingress rules (attribute-as-blocks). | `list(object)` | `[]` | no |
| egress | (Optional) Specifies egress rules (attribute-as-blocks). | `list(object)` | `[]` | no |
| tags | (Optional) A map of tags to assign to the resource. | `map(string)` | `{}` | no |
