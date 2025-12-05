# Setup run to create test VPC
run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  variables {
    vpc_name       = "test-vpc-for-subnet-module"
    vpc_cidr_block = "10.0.0.0/16"
    vpc_tags = {
      "hkjc:account-name" = "finance-team-member"
      "hkjc:cost-centre"  = "546.000.626.00"
      "Purpose"           = "subnet-module-testing"
    }
  }
}

# Comprehensive subnet module test covering all scenarios
run "subnet_comprehensive_test" {
  command = apply

  variables {
    vpc_id                   = run.setup.vpc_id
    subnet_name              = "test-subnet-comprehensive"
    subnet_cidr_block        = "10.0.1.0/24"
    subnet_availability_zone = "ap-guangzhou-3"
    subnet_is_multicast      = false
    subnet_cdc_id            = null
    subnet_route_table_id    = null
    subnet_tags = {
      "hkjc:account-name" = "finance-team-member"
      "hkjc:cost-centre"  = "546.000.626.00"
    }
  }

  # Assert subnet is created with correct name
  assert {
    condition     = tencentcloud_subnet.this.name == var.subnet_name
    error_message = <<-EOT
        The subnet name does not match the expected value.
        Expected: ${var.subnet_name}
        Actual: ${tencentcloud_subnet.this.name}
        EOT
  }

  # Assert subnet CIDR block is set correctly
  assert {
    condition     = tencentcloud_subnet.this.cidr_block == var.subnet_cidr_block
    error_message = <<-EOT
        The subnet CIDR block does not match the expected value.
        Expected: ${var.subnet_cidr_block}
        Actual: ${tencentcloud_subnet.this.cidr_block}
        EOT
  }

  # Assert availability zone is configured correctly
  assert {
    condition     = tencentcloud_subnet.this.availability_zone == var.subnet_availability_zone
    error_message = <<-EOT
        The subnet availability zone does not match the expected value.
        Expected: ${var.subnet_availability_zone}
        Actual: ${tencentcloud_subnet.this.availability_zone}
        EOT
  }

  # Assert VPC ID is set correctly
  assert {
    condition     = tencentcloud_subnet.this.vpc_id == run.setup.vpc_id
    error_message = <<-EOT
        The VPC ID does not match the expected value from setup.
        Expected: ${run.setup.vpc_id}
        Actual: ${tencentcloud_subnet.this.vpc_id}
        EOT
  }
}
