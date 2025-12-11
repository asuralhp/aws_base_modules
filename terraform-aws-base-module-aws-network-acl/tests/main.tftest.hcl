run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  variables {
    vpc_cidr_block = "10.10.0.0/16"
    vpc_tags = {
      Purpose = "network-acl-module-testing"
    }
  }
}

run "create_acl_basic" {
  command = apply

  variables {
    vpc_id     = run.setup.vpc_id
    subnet_ids = run.setup.subnet_ids
    ingress = [
      {
        rule_no    = 100
        protocol   = "-1"
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
      }
    ]
    egress = [
      {
        rule_no    = 100
        protocol   = "-1"
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
      }
    ]
  }

  assert {
    condition     = length(aws_network_acl.this.id) > 0
    error_message = "Network ACL ID should be non-empty"
  }

  assert {
    condition     = length(aws_network_acl_association.this) == length(run.setup.subnet_ids)
    error_message = "Expected ACL associations for all provided subnets"
  }
}
