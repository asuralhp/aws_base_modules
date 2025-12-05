variable "subnet_availability_zone" {
  description = <<-EOT
    (Required) The availability zone where the subnet resides.

    Requirements:
    - Must be a valid availability zone string in the region.
    - Should be chosen based on your service deployment strategy.
    - Cannot be changed after creation (ForceNew).
    - Used to specify the geographic location for the subnet.
    - ap-guangzhou-3, ap-guangzhou-6, ap-guangzhou-7, ap-hongkong-1, ap-hongkong-2, ap-hongkong-3 are supported zones.

    Example: "ap-guangzhou-3"
    EOT
  type        = string
  validation {
    condition     = contains(["ap-guangzhou-3", "ap-guangzhou-6", "ap-guangzhou-7", "ap-hongkong-3", "ap-hongkong-1", "ap-hongkong-2"], var.subnet_availability_zone)
    error_message = "subnet_availability_zone must be one of: ap-guangzhou-3, ap-guangzhou-6, ap-guangzhou-7, ap-hongkong-3, ap-hongkong-2, ap-hongkong-1."
  }
}

variable "subnet_cidr_block" {
  description = <<-EOT
    (Required) The network CIDR block of the subnet.

    Requirements:
    - Must be a valid CIDR block within the VPC CIDR range.
    - Should not overlap with other subnets in the same VPC.
    - Cannot be changed after creation (ForceNew).
    - Used to define the IP address range for the subnet.

    Example: "10.0.1.0/24"
    EOT
  type        = string
  validation {
    condition     = length(var.subnet_cidr_block) > 0
    error_message = "subnet_cidr_block must be a non-empty string."
  }
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.subnet_cidr_block))
    error_message = "subnet_cidr_block must be a valid CIDR notation (e.g., 10.0.1.0/24)."
  }
}

variable "subnet_name" {
  description = <<-EOT
    (Required) The name of the subnet to be created.

    Requirements:
    - Must be a valid subnet name string.
    - Should be descriptive and meaningful for identification.
    - Used to identify and reference the subnet in Tencent Cloud.
    - Must follow the naming pattern: only lowercase letters, numbers, and hyphens ([a-z0-9-]).

    Example: "prod-web-subnet"
    EOT
  type        = string
  validation {
    condition     = length(var.subnet_name) > 0
    error_message = "subnet_name must be a non-empty string."
  }
  validation {
    condition     = length(var.subnet_name) <= 64
    error_message = "subnet_name must not exceed 64 characters."
  }
  validation {
    condition     = can(regex("^([a-z0-9-]+)$", var.subnet_name))
    error_message = "subnet_name must only contain lowercase letters, numbers, and hyphens ([a-z0-9-])."
  }
}

variable "vpc_id" {
  description = <<-EOT
    (Required) The ID of the associated VPC.

    Requirements:
    - Must be a valid VPC ID string.
    - Should reference an existing VPC in your account.
    - Cannot be changed after creation (ForceNew).
    - Used to specify which VPC the subnet belongs to.

    Example: "vpc-12345678"
    EOT
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "vpc_id must be a non-empty string."
  }
  validation {
    condition     = can(regex("^vpc-[a-z0-9]{8}$", var.vpc_id))
    error_message = "vpc_id must start with 'vpc-' followed by 8 lowercase letters or numbers."
  }
}

variable "subnet_cdc_id" {
  description = <<-EOT
    (Optional) The CDC instance ID.

    Requirements:
    - Can be null or a valid CDC instance ID string.
    - Should reference an existing CDC instance in your account.
    - Cannot be changed after creation (ForceNew).
    - Used to associate the subnet with a specific CDC instance.

    Example: "cdc-12345678"
    EOT
  type        = string
  default     = null
  validation {
    condition     = var.subnet_cdc_id == null || can(regex("^cdc-[a-z0-9]{8}$", var.subnet_cdc_id))
    error_message = "subnet_cdc_id must start with 'cdc-' followed by 8 lowercase letters or numbers."
  }
}

variable "subnet_is_multicast" {
  description = <<-EOT
    (Optional) Whether to enable multicast functionality.

    Requirements:
    - Must be a boolean value.
    - When true, multicast functionality is enabled for the subnet.
    - When false, multicast functionality is disabled for the subnet.
    - Used to control multicast traffic within the subnet.

    Example: true
    EOT
  type        = bool
  default     = true
  validation {
    condition     = var.subnet_is_multicast == true || var.subnet_is_multicast == false
    error_message = "subnet_is_multicast must be a boolean value (true or false)."
  }
}


variable "subnet_route_table_id" {
  description = <<-EOT
    (Optional) The route table ID that the subnet should be associated with.

    Requirements:
    - Can be null or a valid route table ID string.
    - Should reference an existing route table in your account.
    - If not provided, the default route table will be used.
    - Used to control routing behavior for the subnet.

    Example: "rtb-12345678"
    EOT
  type        = string
  default     = null
  validation {
    condition     = var.subnet_route_table_id == null || can(regex("^rtb-[a-z0-9]{8}$", var.subnet_route_table_id))
    error_message = "subnet_route_table_id must start with 'rtb-' followed by 8 lowercase letters or numbers."
  }
}

variable "subnet_tags" {
  description = <<-EOT
    (Requried) Key-value pairs for categorizing and organizing resources.

    Requirements:
    - Must be a map of string key-value pairs.
    - Useful for resource management, cost allocation, and access control.
    - Default subnet_tags include department, project, and owner information.

    Example: {
      hkjc:account-name = "finance-team-member"
      hkjc:cost-centre = "546.000.626.00"
    }
    EOT
  type        = map(string)

  # check key length. 127 max
  validation {
    condition = alltrue([
      for key in keys(var.subnet_tags) : can(length(key) <= 127)
    ])
    error_message = "Tag *keys* are restricted to a maximum of 127 characters."
  }

  # check value length. 255 max
  validation {
    condition = alltrue([
      for value in values(var.subnet_tags) : can(length(value) <= 255)
    ])
    error_message = "Tag *keys* are restricted to a maximum of 255 characters."
  }

  validation {
    condition = alltrue([
      for key in keys(var.subnet_tags) : can(regex("^[a-z0-9:-]+$|^Name$", key))
    ])
    error_message = "Tag *keys* allow only the following characters: lowercase letters, 0 to 9, colon, and dash: [a-z0-9:-], Or Name with an uppercase 'N'"
  }

  validation {
    condition = alltrue([
      for value in values(var.subnet_tags) : can(regex("^[a-z0-9:\\-_.]+$", value))
    ])
    error_message = "Tag *values* allow only the following characters: lowercase letters, 0 to 9, colon, dash, period, and square brackets: [a-z0-9:-.[]]"
  }

  validation {
    condition     = length(var.subnet_tags) >= 2
    error_message = <<-EOT
      The *map* of tags must contain at least the following 2 elements.
      Minimum required tags are:
        hkjc:account-name = "finance-team-member"
        hkjc:cost-centre = "546.000.626.00"
    EOT
  }

  validation {
    condition     = length(var.subnet_tags) <= 40
    error_message = "The *map* of subnet_tags must contain 40 elements or less."
  }

  # mandatory account name
  validation {
    condition = anytrue([
      for key in keys(var.subnet_tags) : can(regex("^hkjc:account-name$", key))
    ])
    error_message = "A tag with the *key* of 'hkjc:account-name' is required"
  }

  # mandatory cost centre
  validation {
    condition = anytrue([
      for key in keys(var.subnet_tags) : can(regex("^hkjc:cost-centre$", key))
    ])
    error_message = "A tag with the *key* of 'hkjc:cost-centre' is required"
  }
}

