resource "aws_subnet" "this" {
  region                                      = var.region
  vpc_id                                      = var.vpc_id
  cidr_block                                  = var.cidr_block
  availability_zone                           = var.availability_zone
  availability_zone_id                        = var.availability_zone_id
  map_public_ip_on_launch                     = var.map_public_ip_on_launch
  private_dns_hostname_type_on_launch         = var.private_dns_hostname_type_on_launch
  enable_lni_at_device_index                  = var.enable_lni_at_device_index
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  tags                                        = var.tags
}