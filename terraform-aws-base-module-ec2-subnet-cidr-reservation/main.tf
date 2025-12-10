resource "aws_ec2_subnet_cidr_reservation" "this" {
  region           = var.region
  subnet_id        = var.subnet_id
  cidr_block       = var.cidr_block
  reservation_type = var.reservation_type

  description = var.description
}
