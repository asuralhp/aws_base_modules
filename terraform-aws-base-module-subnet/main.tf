resource "aws_subnet" "this" {
  vpc_id                                = var.vpc_id
  assign_ipv6_address_on_creation       = var.assign_ipv6_address_on_creation
  cidr_block                            = var.cidr_block
  availability_zone                     = var.availability_zone
  availability_zone_id                  = var.availability_zone_id
  ipv6_cidr_block                       = var.ipv6_cidr_block
  map_public_ip_on_launch               = var.map_public_ip_on_launch
  private_dns_hostname_type_on_launch   = var.private_dns_hostname_type_on_launch
  enable_dns64                          = var.enable_dns64
  customer_owned_ipv4_pool              = var.customer_owned_ipv4_pool
  outpost_arn                           = var.outpost_arn
  enable_lni_at_device_index            = try(var.enable_lni_at_device_index, null)
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch   = var.enable_resource_name_dns_a_record_on_launch
  ipv6_native                           = var.ipv6_native
  map_customer_owned_ip_on_launch       = var.map_customer_owned_ip_on_launch

  tags = var.tags
}