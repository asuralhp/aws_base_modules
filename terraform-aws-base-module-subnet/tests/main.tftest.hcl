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
    vpc_id             = run.setup.vpc_id
    cidr_block         = "10.0.1.0/24"
    availability_zone  = "ap-east-1a"
    map_public_ip_on_launch = false
    tags = {
      Name        = "test-subnet-comprehensive"
      environment = "test"
    }
  }

  # Assert subnet is created with correct name
  assert {
    condition     = aws_subnet.this.tags["Name"] == var.tags["Name"]
    error_message = <<-EOT
        The subnet Name tag does not match the expected value.
        Expected: ${var.tags["Name"]}
        Actual: ${aws_subnet.this.tags["Name"]}
        EOT
  }

  # Assert subnet CIDR block is set correctly
  assert {
    condition     = aws_subnet.this.cidr_block == var.cidr_block
    error_message = <<-EOT
        The subnet CIDR block does not match the expected value.
        Expected: ${var.cidr_block}
        Actual: ${aws_subnet.this.cidr_block}
        EOT
  }

  # Assert availability zone is configured correctly
  assert {
    condition     = aws_subnet.this.availability_zone == var.availability_zone
    error_message = <<-EOT
        The subnet availability zone does not match the expected value.
        Expected: ${var.availability_zone}
        Actual: ${aws_subnet.this.availability_zone}
        EOT
  }

  # Assert VPC ID is set correctly
  assert {
    condition     = aws_subnet.this.vpc_id == run.setup.vpc_id
    error_message = <<-EOT
        The VPC ID does not match the expected value from setup.
        Expected: ${run.setup.vpc_id}
        Actual: ${aws_subnet.this.vpc_id}
        EOT
  }
}
