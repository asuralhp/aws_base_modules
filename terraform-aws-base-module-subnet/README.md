# terraform-aws-base-module-subnet

A reusable, opinionated Terraform module for creating and managing an AWS Subnet within a Virtual Private Cloud (VPC). This module abstracts the configuration of subnets, ensuring consistent tagging and validation for IPv4-only networking.

---

## What Does This Module Do?

- **Creates an AWS Subnet** within a specified VPC.
- **Supports IPv4** addressing scheme.
- **Configures Public IP Assignment** for instances launched in the subnet.
- **Manages DNS Settings** including private DNS hostnames and DNS A/AAAA records.
- **Enforces Input Validation** for critical parameters like VPC ID and CIDR blocks.
- **Outputs key attributes** for easy integration with other resources (e.g., Route Tables, NACLs, EC2 instances).

---

## How It Works

This module wraps the standard `aws_subnet` resource, adding a layer of input validation and simplified configuration for common networking scenarios. You provide the VPC context, addressing requirements, and placement preferences, and the module handles the provisioning.

### Step-by-Step Flow

1. **VPC Context:**
   You provide the `vpc_id` where the subnet will reside. The module validates that the ID format is correct.

2. **Addressing & Placement:**
  You define the `cidr_block` (IPv4). You can also pin the subnet to a specific `availability_zone` or `availability_zone_id`.

3. **Network Configuration:**
   You configure behavior such as `map_public_ip_on_launch` (for public subnets) and DNS settings (`enable_resource_name_dns_a_record_on_launch`, etc.).

4. **Resource Creation:**
   The module provisions the `aws_subnet` resource with the specified configuration and tags.

5. **Outputs:**
   The module exports the Subnet ID, ARN, and other details for use in your broader infrastructure (e.g., associating with a Route Table).

---

## Resources Created

- **aws_subnet.this**: The primary subnet resource created within the specified VPC.

---

## Usage Examples

### Basic Private Subnet

```hcl
module "private_subnet" {
  source = "git::https://github.com/your-org/terraform-aws-base-module-subnet.git?ref=v1.0.0"

  vpc_id            = "vpc-0a1b2c3d4e5f67890"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-east-1a"

  tags = {
    Name        = "my-private-subnet"
    Environment = "dev"
  }
}
```

### Public Subnet with Auto-Assign Public IP

```hcl
module "public_subnet" {
  source = "git::https://github.com/your-org/terraform-aws-base-module-subnet.git?ref=v1.0.0"

  vpc_id                  = "vpc-0a1b2c3d4e5f67890"
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "my-public-subnet"
    Environment = "dev"
    Tier        = "public"
  }
}
```

 

---

## What Is Produced

When you apply this module, it produces:

1. **An AWS Subnet** in the specified VPC and Availability Zone.
2. **Terraform Outputs** including:
   - `aws_subnet_id`: The ID of the created subnet.
   - `aws_subnet_arn`: The ARN of the subnet.
   - `aws_subnet`: The full object of the created resource.

---

## Inputs Explained

- **vpc_id**: (Required) The ID of the VPC.
- **cidr_block**: (Required) The IPv4 CIDR block.
- **availability_zone**: (Optional) The AZ name (e.g., `us-east-1a`).
- **map_public_ip_on_launch**: (Optional) Auto-assign public IPs to instances.
- **tags**: (Optional) A map of tags to assign to the resource.

(See full Inputs table below)

---

## Outputs Explained

- **aws_subnet_id**: The unique identifier of the subnet.
- **aws_subnet_arn**: The Amazon Resource Name (ARN) of the subnet.
- **aws_subnet_tags_all**: All tags assigned to the subnet.

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | The ID of the VPC that will contain this subnet. | `string` | n/a | yes |
| cidr_block | IPv4 CIDR block to assign to the subnet. | `string` | n/a | yes |
| availability_zone | AWS Availability Zone where the subnet will be created. | `string` | `null` | no |
| availability_zone_id | The Availability Zone ID to use for the subnet. | `string` | `null` | no |
| map_public_ip_on_launch | If true, instances launched into the subnet will receive a public IPv4 address by default. | `bool` | `false` | no |
| enable_resource_name_dns_a_record_on_launch | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. | `bool` | `false` | no |
 
| private_dns_hostname_type_on_launch | The type of hostnames to assign to instances in the subnet at launch. | `string` | `null` | no |
| enable_lni_at_device_index | Indicates the device position for local network interfaces in this subnet. | `number` | `null` | no |
| tags | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| region | Region where this resource should be managed. | `string` | `"ap-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_subnet | All values from the AWS subnet resource. |
| aws_subnet_id | The ID of the subnet. |
| aws_subnet_arn | The ARN of the subnet. |
| aws_subnet_tags_all | All tags assigned to the subnet. |
| aws_subnet_owner_id | AWS account ID that owns the subnet. |
 
