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

# Basic subnet test (no Outpost/customer-owned IPs)
run "subnet_basic_test" {
  command = apply

  variables {
    vpc_id     = run.setup.vpc_id
    cidr_block = "10.0.1.0/24"
    # Do not pin an AZ here to avoid regional AZ mismatches in CI/test runs
    map_public_ip_on_launch = false
    tags = {
      Name        = "test-subnet-basic"
      environment = "test"
    }
  }

  # Assert subnet was created in the expected VPC
  assert {
    condition     = aws_subnet.this.vpc_id == run.setup.vpc_id
    error_message = <<-EOT
      The subnet was not created in the expected VPC.
      Expected VPC ID: ${run.setup.vpc_id}
      Actual: ${aws_subnet.this.vpc_id}
      EOT
  }

  # Assert CIDR block
  assert {
    condition     = aws_subnet.this.cidr_block == var.cidr_block
    error_message = <<-EOT
      The subnet CIDR block does not match the expected value.
      Expected: ${var.cidr_block}
      Actual: ${aws_subnet.this.cidr_block}
      EOT
  }

  # Assert Name tag
  assert {
    condition     = aws_subnet.this.tags["Name"] == var.tags["Name"]
    error_message = <<-EOT
      The subnet Name tag does not match the expected value.
      Expected: ${var.tags["Name"]}
      Actual: ${aws_subnet.this.tags["Name"]}
      EOT
  }
}
