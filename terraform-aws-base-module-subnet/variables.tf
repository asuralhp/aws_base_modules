variable "vpc_id" {
  description = <<-EOT
    (Required) The ID of the VPC that will contain this subnet.

    Requirements:
    - Must reference an existing AWS VPC in the same account and region where you plan to create the subnet.
    - Must be a non-empty string and conform to the AWS VPC identifier pattern (typically starts with "vpc-").
    - Changing this value after creation will replace the subnet (ForceNew behavior).

    Example: "vpc-0a1b2c3d4e5f67890"
  EOT
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "The VPC ID must be a non-empty string (e.g. 'vpc-0123456789abcdef0')."
  }

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "Invalid VPC ID format. VPC IDs typically start with 'vpc-'."
  }
}

variable "region" {
  description = <<-EOT
    (Optional) Region where this resource should be managed.

    Notes:
    - By default, ap-east-1 will be used.
    - To manage this resource in a different region from the provider default, use a provider alias and pass that provider when instantiating the module (example documented in README).
  EOT
  type        = string
  default     = "ap-east-1"
}

variable "cidr_block" {
  description = <<-EOT
    (Required) IPv4 CIDR block to assign to the subnet.

    Requirements:
    - Must be a valid IPv4 CIDR notation and contained within the parent VPC CIDR.
    - Must not overlap with other subnets in the same VPC.
    - Changing this value after creation is not supported (ForceNew behavior).

    Example: "10.0.1.0/24"
  EOT
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Invalid CIDR block. Provide a valid IPv4 CIDR (e.g. 10.0.1.0/24)."
  }
}

variable "availability_zone" {
  description = <<-EOT
    (Optional) AWS Availability Zone where the subnet will be created.

    Notes:
    - Provide either `availability_zone` or `availability_zone_id` when you need to pin the subnet to a specific AZ.
    - If omitted, AWS may select an AZ for you.
    - Changing this value after creation may recreate the resource.

    Example: "us-east-1a"
  EOT
  type        = string
  default     = null

  validation {
    condition     = var.availability_zone == null || length(trimspace(var.availability_zone)) > 0
    error_message = "When provided, availability_zone must be a non-empty string (e.g. 'us-east-1a')."
  }
}

variable "availability_zone_id" {
  description = <<-EOT
    (Optional) The Availability Zone ID to use for the subnet (for example: "use1-az1").

    Notes:
    - This is the AZ identifier (AZ ID), not the AZ name. Use it when you need AZ stability across accounts/regions.
    - Provide either `availability_zone` or `availability_zone_id` but not both unless required.
    - Changing this value after creation may recreate the subnet.

    Example: "use1-az1"
  EOT
  type        = string
  default     = null

  validation {
    condition     = var.availability_zone_id == null || length(trimspace(var.availability_zone_id)) > 0
    error_message = "When provided, availability_zone_id must be a non-empty AZ identifier string."
  }
}

variable "map_public_ip_on_launch" {
  description = <<-EOT
    (Optional) If true, instances launched into the subnet will receive a public IPv4 address by default.

    Notes:
    - This setting controls the subnet-level auto-assign public IP behavior.
    - Default is `false` to prefer private-only subnets.
  EOT
  type        = bool
  default     = false
}


variable "private_dns_hostname_type_on_launch" {
  description = <<-EOT
    (Optional) Controls the type of private DNS hostname assigned to EC2 instances at launch.

    Accepted values:
    - "ip-name": hostname based on the private IPv4 address
    - "resource-name": resource-based hostname

    Default: "ip-name"
  EOT
  type        = string
  default     = "ip-name"

  validation {
    condition     = can(regex("^(ip-name|resource-name)$", var.private_dns_hostname_type_on_launch))
    error_message = "Invalid value: private_dns_hostname_type_on_launch must be 'ip-name' or 'resource-name'."
  }
}




variable "tags" {
  description = <<-EOT
 	(Required) Key-value pairs for categorizing and organizing resources.
 
	Requirements:
 	- Must be a map of string key-value pairs.
 	- Useful for resource management, cost allocation, and access control.
 	- Maximum 50 tags allowed.
 
	Example:
   	tags = {
     	Name    	= "my-vpc"
     	Environment = "dev"
     	Project 	= "website"
   	}
   EOT
  type        = map(string)
  validation {
    condition     = length(keys(var.tags)) <= 50
    error_message = "The VPC tags must not exceed 50 tags."
  }
  validation {
    condition     = contains(keys(var.tags), "Name")
    error_message = "A 'Name' tag must be set in the tags map."
  }
}

variable "enable_lni_at_device_index" {
  description = <<-EOT
    (Optional) Device index to enable local network interfaces on the subnet.

    Notes:
    - When set, indicates the device position for local network interfaces in this subnet (for example, 1 -> eth1).
    - Must be a positive integer when provided.
  EOT
  type        = number
  default     = null

  validation {
    condition     = var.enable_lni_at_device_index == null || (var.enable_lni_at_device_index >= 1)
    error_message = "enable_lni_at_device_index must be a positive integer when provided."
  }
}



variable "enable_resource_name_dns_a_record_on_launch" {
  description = <<-EOT
    (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS A records.

    Default: `false`.
  EOT
  type        = bool
  default     = false
}






