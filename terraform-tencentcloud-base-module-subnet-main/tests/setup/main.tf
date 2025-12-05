# Helper module to create a test VPC for subnet testing
resource "tencentcloud_vpc" "test_vpc" {
  name         = var.vpc_name
  cidr_block   = var.vpc_cidr_block
  dns_servers  = var.vpc_dns_servers
  is_multicast = var.vpc_is_multicast
  tags         = var.vpc_tags
}
