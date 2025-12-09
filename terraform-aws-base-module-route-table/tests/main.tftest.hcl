# Setup run to create test VPC and IGW
run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  variables {
    vpc_name       = "test-vpc-for-route-table"
    vpc_cidr_block = "10.1.0.0/16"
    vpc_tags = {
      Purpose = "route-table-module-testing"
    }
  }
}

# Route table tests
run "route_table_basic" {
  command = apply

  variables {
    vpc_id = run.setup.vpc_id
    # omit `route` so no external routes are created for this test
    tags = {
      Name = "test-rt"
    }
  }

  assert {
    condition     = aws_route_table.this.vpc_id == run.setup.vpc_id
    error_message = "Route table VPC ID does not match expected setup VPC ID."
  }

  # Ensure no external routes were created by default in the test
  assert {
    condition     = length(aws_route_table.this.route) == 0
    error_message = "Route table unexpectedly contains inline routes."
  }
}
