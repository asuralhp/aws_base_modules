resource "tencentcloud_subnet" "this" {
  vpc_id            = var.vpc_id
  name              = var.subnet_name
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.subnet_availability_zone
  is_multicast      = var.subnet_is_multicast
  cdc_id            = var.subnet_cdc_id
  route_table_id    = var.subnet_route_table_id
  tags              = var.subnet_tags
}
