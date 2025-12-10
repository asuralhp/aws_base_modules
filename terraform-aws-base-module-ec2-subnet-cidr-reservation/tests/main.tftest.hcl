# Setup run to create a VPC and subnet for tests
run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  variables {
    vpc_name       = "test-vpc-for-cidr-reservation"
    vpc_cidr_block = "10.2.0.0/16"
    vpc_tags = {
      Purpose = "cidr-reservation-testing"
    }
  }
}

# Test creating a CIDR reservation in the created subnet
run "cidr_reservation_test" {
  command = apply

  variables {
    subnet_id        = run.setup.subnet_id
    cidr_block       = "10.2.1.0/28"
    reservation_type = "explicit"
    description      = "test reservation"
    tags = {
      Name = "test-reservation"
    }
  }

  assert {
    condition     = aws_ec2_subnet_cidr_reservation.this.cidr_block == var.cidr_block
    error_message = "CIDR on reservation does not match expected value."
  }

  assert {
    condition     = aws_ec2_subnet_cidr_reservation.this.subnet_id == run.setup.subnet_id
    error_message = "Reservation subnet_id does not match setup subnet."
  }
}
