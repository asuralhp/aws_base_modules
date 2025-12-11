run "create_tgw_basic" {
  command = apply

  variables {
    description                     = "Test TGW"
    auto_accept_shared_attachments  = "disable"
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    dns_support                     = "enable"
    multicast_support               = "disable"
  }

  assert {
    condition     = length(aws_ec2_transit_gateway.this.id) > 0
    error_message = "Transit Gateway ID should be non-empty"
  }
}
